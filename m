Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A6641776;
	Thu, 14 Dec 2023 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTdkSdM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1B7C433C7;
	Thu, 14 Dec 2023 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702568029;
	bh=3dRVPojxVarxqc+k64+h1j/nb68HVbqD8FQgiohBXbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XTdkSdM1sLzi4D/PSBmJ2eDH19Bmp4X+y6BgJ1F+GShGRM/Cw/ypKQnB9w8xbS4Xu
	 CfX5oreZxh4gy08/z77Gy3aRf/0oHo1S1w0oZnvwEsfrfYcepS9/iwpPTNyn5Mtl2x
	 HkAJlUHreRrUpbQiCjy1h/wWRPLQ19pRl+imLyBk=
Date: Thu, 14 Dec 2023 16:33:47 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] driver core: Add a guard() definition for the
 device_lock()
Message-ID: <2023121456-violation-unthawed-3ae3@gregkh>
References: <170250854466.1522182.17555361077409628655.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250854466.1522182.17555361077409628655.stgit@dwillia2-xfh.jf.intel.com>

On Wed, Dec 13, 2023 at 03:02:35PM -0800, Dan Williams wrote:
> At present there are ~200 usages of device_lock() in the kernel. Some of
> those usages lead to "goto unlock;" patterns which have proven to be
> error prone. Define a "device" guard() definition to allow for those to
> be cleaned up and prevent new ones from appearing.
> 
> Link: http://lore.kernel.org/r/657897453dda8_269bd29492@dwillia2-mobl3.amr.corp.intel.com.notmuch
> Link: http://lore.kernel.org/r/6577b0c2a02df_a04c5294bb@dwillia2-xfh.jf.intel.com.notmuch
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Hi Greg,
> 
> I wonder if you might include this change in v6.7-rc to ease some patch
> sets alternately going through my tree and Andrew's tree. Those
> discussions are linked above. Alternately I can can just take it through
> my tree with your ack and the other use case can circle back to it in
> the v6.9 cycle.

Sure, I'll queue it up now for 6.7-final, makes sense to have it now for
others to build off of, and for me to fix up some places in the driver
core to use it as well.

> I considered also defining a __free() helper similar to __free(mutex),
> but I think "__free(device)" would be a surprising name for something
> that drops a lock. Also, I like the syntax of guard(device) over
> something like guard(device_lock) since a 'struct device *' is the
> argument, not a lock type, but I'm open to your or Peter's thoughts on
> the naming.

guard(device); makes sense to me, as that's what you are doing here, so
I'm good with it.

thanks,

greg k-h
