Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E11972
	for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=4YN8DKc/50CxJ1/q46BvmC8TnMeGci9z1miBkCyhNpU=; b=FV3owrfnS0CfUbnuX9OXOFFqJX
	NmdXz/DOByNNeprGTa6FC6aCLvgPTkCUorqFQSUa+L8LcKCSn304KpqFF6IrnnLOyTrD+evEDLQNK
	0ozka9hMYFCBdJJi2TW7fTAaOcYdSEWqAhbmHvvJybh5ws+8VX5lV7FbxZ9oHcRz52mpd+MYzcmQY
	q9LHMBOH2BBDn2Qqjlgaf7ipi7kV+dlrv7WbmGGZKTuh7jReVQZfRggusg5qsRfyB1SLDw0PUdCl6
	sj1lMU6/nR3d9jQhIR7slT5in4a2hvAfpyIJmBmlT5iK/ycRhNn1PBughoXKBA+URp0XO1NddfCzi
	QwHixX/g==;
Received: from [2602:306:c5a2:a380:b27b:25ff:fe2c:51a8]
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mgTW9-00D6lg-CO; Fri, 29 Oct 2021 15:10:05 +0000
Subject: Re: [PATCH 11/13] ps3vram: add error handling support for add_disk()
To: Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
 mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
 jim@jtan.com, minchan@kernel.org, ngupta@vflare.org,
 senozhatsky@chromium.org, richard@nod.at, miquel.raynal@bootlin.com,
 vigneshr@ti.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, ira.weiny@intel.com, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me
Cc: linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211015235219.2191207-1-mcgrof@kernel.org>
 <20211015235219.2191207-12-mcgrof@kernel.org>
From: Geoff Levand <geoff@infradead.org>
Message-ID: <2b782451-f931-27bb-1114-2aba450c5879@infradead.org>
Date: Fri, 29 Oct 2021 08:09:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20211015235219.2191207-12-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi Luis,

On 10/15/21 4:52 PM, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.

I didn't yet test this ps3vram related change, but based
on the ps3disk testing I think this change will be OK.

Acked-by: Geoff Levand <geoff@infradead.org>
