Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DDE3D8E
	for <nvdimm@lists.linux.dev>; Mon, 13 Jun 2022 23:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zObLgYLKaX93eqNdhzg3WCjAdYsBSVDmp1swEyP75Z8=; b=KowdyPlmA1k3oZhYWZ+axPGuPF
	w01vx8DloeDtGGYdCjeAMqAI5RU2QAQCmyI+qVgyNUd3SYQ20o3MpcHh1+JEnrG5WchLgzZ8LhrEY
	FLjzAii9mRwNr8Juav+Z8yA+I2mU0wxt5fNnv1CB+FFNmhO3EtTFOXWa6FK6+pQZYqLNyIhmytLcZ
	Uye67DsxU0yLicruRin9LPCeA3ZGDPyJfiYtJhQA50Qn8vMWfz7G01K8nHA1n+rD+lNiyi5uoXX6d
	yjIg/+qy/WVCfwi8vR7hMqnIvdyhBm9tWseTjq6WK6JsJYyz/qxF9tYvpG6Mll4SLwsbFZEiSr7w8
	utn9yywg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
	id 1o0tZW-0005lI-5G;
	Mon, 13 Jun 2022 23:34:14 +0000
Date: Tue, 14 Jun 2022 00:34:14 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	nvdimm@lists.linux.dev, David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH] fix short copy handling in copy_mc_pipe_to_iter()
Message-ID: <YqfJdup4nsOLXXrL@ZenIV>
References: <YqaAcKsd6uGfIQzM@zeniv-ca.linux.org.uk>
 <CAHk-=wjmCzdNDCt6L8-N33WSRaYjnj0=yTc_JG8A_Pd7ZEtEJw@mail.gmail.com>
 <Yqe6EjGTpkvJUU28@ZenIV>
 <YqfHT7Ha/N/wAdcG@ZenIV>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqfHT7Ha/N/wAdcG@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jun 14, 2022 at 12:25:03AM +0100, Al Viro wrote:

> The more I'm looking at that thing, the more it smells like a bug;
> it had the same 3 callers since the time it had been introduced.
> 
> 1) pipe_get_pages().  We are about to try and allocate up to that
> many pipe buffers.  Allocation (done in push_pipe()) is done only
> if we have !pipe_full(pipe->head, pipe->tail, pipe->max_usage).
> 
> It simply won't give you more than max_usage - occupancy.
> Your function returns min(ring_size - occupancy, max_usage), which
> is always greater than or equal to that (ring_size >= max_usage).
> 
> 2) pipe_get_pages_alloc().  Same story, same push_pipe() being
> called, same "we'll never get that much - it'll hit the limit
> first".
> 
> 3) iov_iter_npages() in case of ITER_PIPE.  Again, the value
> is bogus - it should not be greater than the amount of pages
> we would be able to write there.
> 
> AFAICS, 6718b6f855a0 "pipe: Allow pipes to have kernel-reserved slots"
> broke it for cases when ring_size != max_usage...

Unless I'm missing something, the following would do the right thing.
Dave?

diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 4ea496924106..c22173d6e500 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -165,15 +165,10 @@ static inline bool pipe_full(unsigned int head, unsigned int tail,
 static inline unsigned int pipe_space_for_user(unsigned int head, unsigned int tail,
 					       struct pipe_inode_info *pipe)
 {
-	unsigned int p_occupancy, p_space;
-
-	p_occupancy = pipe_occupancy(head, tail);
+	unsigned int p_occupancy = pipe_occupancy(head, tail);
 	if (p_occupancy >= pipe->max_usage)
 		return 0;
-	p_space = pipe->ring_size - p_occupancy;
-	if (p_space > pipe->max_usage)
-		p_space = pipe->max_usage;
-	return p_space;
+	return pipe->max_usage - p_occupancy;
 }
 
 /**
