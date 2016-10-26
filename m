Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A4691A1E29
 for <linux-nvdimm@lists.01.org>; Wed, 26 Oct 2016 02:23:32 -0700 (PDT)
Date: Wed, 26 Oct 2016 11:23:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [4.4, 4.7 stable PATCH] acpi, nfit: check for the correct event
 code in notifications
Message-ID: <20161026092339.GC989@kroah.com>
References: <1477346286-27012-1-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1477346286-27012-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 24, 2016 at 03:58:06PM -0600, Vishal Verma wrote:
> commit c09f12186d6b03b798832d95289af76495990192 upstream.
> 
> Commit 209851649dc4 "acpi: nfit: Add support for hot-add" added
> support for _FIT notifications, but it neglected to verify the
> notification event code matches the one in the ACPI spec for
> "NFIT Update". Currently there is only one code in the spec, but
> once additional codes are added, older kernels (without this fix)
> will misbehave by assuming all event notifications are for an
> NFIT Update.
> 
> Fixes: 209851649dc4 ("acpi: nfit: Add support for hot-add")
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
> 
> Note that the patch doesn't directly apply to stable-4.4, but using
> 'git am -3' works. Is this sufficient, or should I send a sepatate
> patch for 4.4?

I've made it fit :)

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
