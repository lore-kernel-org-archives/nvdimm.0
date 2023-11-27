Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDCCD28D
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ00NQ1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15105C433C8;
	Mon, 27 Nov 2023 08:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701073709;
	bh=WwwTk67B+jebznC/ZbMXIagwkywTr4uzTbOuuletspo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KZ00NQ1ptrEUa8CMTjBBLe0vKMpaMO72h9YeJjE+ew/xh2DNF+0uZhSFq6vKj2J8w
	 w/I3SR2vnKtV7FBf9q31iPvCPx8hd3sG5BxmyyPcpLCFpGcqCyk6vMpoE5RVeTCrni
	 SLzvQAp3+A4CML3bb6WwV2p0HA0FqSV2s1kjfmj4=
Date: Mon, 27 Nov 2023 08:28:26 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Yi Zhang <yi.zhang@redhat.com>
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com
Subject: Re: [PATCH] ndtest: fix typo class_regster -> class_register
Message-ID: <2023112748-appraiser-bristle-a2b9@gregkh>
References: <20231127040026.362729-1-yi.zhang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127040026.362729-1-yi.zhang@redhat.com>

On Mon, Nov 27, 2023 at 12:00:26PM +0800, Yi Zhang wrote:
> Fixes: dd6cad2dcb58 ("testing: nvdimm: make struct class structures constant")
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/process/submitting-patches.rst for what is needed in
  order to properly describe the change.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
