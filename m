Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE83668
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M+KuJQ3Pij3vq+0we6vwJ0jmx0Ngow3BIyNmiozxHWw=; b=Zj8SxV2eOkRGfCcnCtlFlo+1TA
	jvKEWj3ewjGlYZYaDUZqJrpHNnrkUQ+Xpqr2k6Kt68dLW1aHctQDfd4MuvFQ+ewTawM/O8HnY9yw7
	veLv1Woq+/D5fSxJt2Zrtua/nKUBrJm2TVtpKX88kH3VfBGLJHws19r0lkg3q3S24MFyo2f42bh6t
	FsEsTnOo6NqYNyRjahehDO2F7i9tNa2WblUNT/TyBUo9+wtUXQ7CUQRE3nomCEf73uQmHL7b4uhlC
	vKp+YeQVsBVYJcs94mt3zfP9J/Mps/VIcMApDtERdntma0FwiUZQ+HH6/gJJ2k0Gtj8lRGcYxDCzx
	84ouUL3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkXAo-0038qy-K2; Tue, 09 Nov 2021 19:52:50 +0000
Date: Tue, 9 Nov 2021 11:52:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>,
	david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Vivek Goyal <vgoyal@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Message-ID: <YYrRkpA0A/FXRpKS@infradead.org>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
 <20211106011638.2613039-3-jane.chu@oracle.com>
 <YYoi2JiwTtmxONvB@infradead.org>
 <CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 09, 2021 at 10:48:51AM -0800, Dan Williams wrote:
> I think we just make error management a first class citizen of a
> dax-device and stop abstracting it behind a driver callback. That way
> the driver that registers the dax-device can optionally register error
> management as well. Then fsdax path can do:

This sound pretty sensible.
