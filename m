Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04A536BCCC;
	Mon,  3 Aug 2026 23:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798771; cv=none; b=HMzHOP0CpdyylMfgKhXQXf2FRHgUfB+2QGDBlnSpaiCw9x1y4T0OiUekE7DQtgcqQY3kLNeVUhl+1XzjM2MLsGlzsrVFktSUew6+O/GAjsFV3AtxSRXydH1bEtivZcj1QVQwtDxnDNMJaZKdkWrG5shhvX3b4i24obtJGneEIXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798771; c=relaxed/simple;
	bh=YGGDnYJClqB+zIUYachuNsvNJvvQ+tQOE2N5107KOaY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJrTDzbzuTZ87YnG6d5GJS0wUh4bBYYtAJ//ihUx11IVpJ6rSr3Y5qE83KYaU+dkrrBs3rBMH2reV6ya52k+X0RNPxRNgF2OqoJKbRupLURzbHj8L0XLPJFV1HTe9mi88GxvwecQ4tFiQyLPvr4vaYqVsV7d04WA0wmP8DrP8ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfCCsPJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfCCsPJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6591F000E9;
	Mon,  3 Aug 2026 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798769;
	bh=5My8vfQlO2Ad3sN9UHV8dLHNG17e513ahh2rKQtcHaM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TfCCsPJmOYIfirjyms5ERD/fX6TS6lkFTZ82IM8p910TIHUWOccaBxrSN+SMYHrPP
	 cNFsE0qUtd6NEWETBjPYu8JIvBTSBNMk5IJhBYBRs6LyPRZ/9h2PxDMrk4MPEdAu+0
	 UsB1Aw9sTXKLMULD0H5mu3sRiXKwYHAawKZ0XZBtnpUIV8+eflTU0uMOJOTZ65nflN
	 PkRF52KZ7XF7Ez5LL/rPdBWQgorVr6/JALSmMpn21tfdHaB3B3JkIOkjd1qwTGPbjJ
	 a1fq4W/kWTBxpmq1Q9isonlAulvZVojeEKhH+BqcmPU2tq7zeM9xrdcStPdcXynn13
	 lKFZonQjR5Cww==
Date: Tue, 4 Aug 2026 00:12:45 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, <linux-cxl@vger.kernel.org>,
 <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Dave Jiang
 <dave.jiang@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin
 Cheatham <benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>,
 Junhee Park <jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>,
 Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 1/8] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <20260804001245.079b16ae@jic23-huawei>
In-Reply-To: <anEIZOTDKsj15Nhp@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
	<20260731084901.1512819-2-anisa.su@samsung.com>
	<anEIZOTDKsj15Nhp@aschofie-mobl2.lan>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Aug 2026 14:30:12 -0700
Alison Schofield <alison.schofield@intel.com> wrote:

> On Fri, Jul 31, 2026 at 01:48:06AM -0700, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Per the CXL 4.0 specification software must check the Command Effects
> > Log (CEL) for dynamic capacity command support.
> > 
> > Detect support for the DCD commands while reading the CEL, including:
> > 
> >         Get DC Config
> >         Get DC Extent List
> >         Add DC Response
> >         Release DC
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> > Tested-by: Junhee Park <jh9934.park@samsung.com>
> > Tested-by: Heesoo Kim <habil.kim@samsung.com>
> > 
> > ---
> > Changes:
> > 1. mbox.c: leave mds->dcd_supported false so the hardware enablement
> >    patches can be upstreamed ahead of the extent and DAX work; the
> >    event handling patch re-enables it.
> > ---
> >  drivers/cxl/core/mbox.c | 44 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxlmem.h    | 20 +++++++++++++++++++
> >  2 files changed, 64 insertions(+)
> > 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 7c6c5b7450a5..4790524c32a7 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -165,6 +165,38 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
> >  	}
> >  }
> >  
> > +static bool cxl_is_dcd_command(u16 opcode)
> > +{
> > +#define CXL_MBOX_OP_DCD_CMDS 0x48
> > +
> > +	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
> > +}
> > +
> > +static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
> > +{
> > +	switch (opcode) {
> > +	case CXL_MBOX_OP_GET_DC_CONFIG:
> > +		set_bit(CXL_DCD_ENABLED_GET_CONFIG, cmd_mask);
> > +		break;
> > +	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
> > +		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, cmd_mask);
> > +		break;
> > +	case CXL_MBOX_OP_ADD_DC_RESPONSE:
> > +		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, cmd_mask);
> > +		break;
> > +	case CXL_MBOX_OP_RELEASE_DC:
> > +		set_bit(CXL_DCD_ENABLED_RELEASE, cmd_mask);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +}
> > +
> > +static bool cxl_verify_dcd_cmds(unsigned long *cmds_seen)
> > +{
> > +	return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);
> > +}
> > +
> >  static bool cxl_is_poison_command(u16 opcode)
> >  {
> >  #define CXL_MBOX_OP_POISON_CMDS 0x43
> > @@ -757,6 +789,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
> >  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> >  	struct cxl_cel_entry *cel_entry;
> >  	const int cel_entries = size / sizeof(*cel_entry);
> > +	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};
> >  	struct device *dev = mds->cxlds.dev;
> >  	int i, ro_cmds = 0, wr_cmds = 0;
> >  
> > @@ -785,11 +818,22 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
> >  			enabled++;
> >  		}
> >  
> > +		if (cxl_is_dcd_command(opcode)) {
> > +			cxl_set_dcd_cmd_enabled(opcode, dcd_cmds);
> > +			enabled++;
> > +		}
> > +
> >  		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
> >  			enabled ? "enabled" : "unsupported by driver");
> >  	}
> >  
> >  	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
> > +	/*
> > +	 * Disabled until event handling implemented.
> > +	 */
> > +	if (cxl_verify_dcd_cmds(dcd_cmds))
> > +		dev_dbg(dev, "Device supports DCD; capability disabled\n");
> > +	mds->dcd_supported = false;
> >  }  
> 
> When I view how this lands in the entirety of cxl_walk_cel() it seems
> to needlessly be different from the pattern set by poison and security
> handling in the same function and structures. Could this follow that
> more closely?  Doing so would remove this 'tail' work here of checking
> and setting the boolean.
> 
> This appended diff touches patch 2 where it has the first caller, but
> pasting all here for simplicity - you'll apply per patch if you take it.
> 
> The bitmap lives in mds structure and it is already where the bool is now.
> The only piece of the poison and security pattern not worth copying
> yet is the wrapper struct cxl_poison_state and struct cxl_security_state
> exist because each grew a mutex and other per-class state, and DCD has
> none of that in this series (yet).
Hi Alison,

This rang a bell as I remembered Ira did it this way originally -
so I did some archaeology.

[PATCH v8 01/21] cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
https://lore.kernel.org/all/67786b76a0c5_f58f294b1@dwillia2-xfh.jf.intel.com.notmuch/

Dan's point was that we need that infrastructure for poison and security
because a subset is a realistic possibility. For DCD today it's all or
nothing so why keep a bitmap around?

I agree there is merit in having all the command types handled the same
but perhaps it is clearer to just have a bool.  Of course when someone
adds another DCD command on the device side (which by definition will have
to be optional) then we will need to revisit.

Jonathan

> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index b18ea02ed2e6..27cfe0ee4752 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -172,7 +172,7 @@ static bool cxl_is_dcd_command(u16 opcode)
>         return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
>  }
> 
> -static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
> +static void cxl_set_dcd_cmd_enabled(unsigned long *cmd_mask, u16 opcode)
>  {
>         switch (opcode) {
>         case CXL_MBOX_OP_GET_DC_CONFIG:
> @@ -192,11 +192,6 @@ static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
>         }
>  }
> 
> -static bool cxl_verify_dcd_cmds(unsigned long *cmds_seen)
> -{
> -       return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);
> -}
> -
>  static bool cxl_is_poison_command(u16 opcode)
>  {
>  #define CXL_MBOX_OP_POISON_CMDS 0x43
> @@ -789,7 +784,6 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>         struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>         struct cxl_cel_entry *cel_entry;
>         const int cel_entries = size / sizeof(*cel_entry);
> -       DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};
>         struct device *dev = mds->cxlds.dev;
>         int i, ro_cmds = 0, wr_cmds = 0;
> 
> @@ -819,7 +813,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>                 }
> 
>                 if (cxl_is_dcd_command(opcode)) {
> -                       cxl_set_dcd_cmd_enabled(opcode, dcd_cmds);
> +                       cxl_set_dcd_cmd_enabled(mds->dcd_enabled_cmds, opcode);
>                         enabled++;
>                 }
> 
> @@ -828,12 +822,6 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>         }
> 
>         set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
> -       /*
> -        * Disabled until event handling implemented.
> -        */
> -       if (cxl_verify_dcd_cmds(dcd_cmds))
> -               dev_dbg(dev, "Device supports DCD; capability disabled\n");
> -       mds->dcd_supported = false;
>  }
> 
>  static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_memdev_state *mds)
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 77f6417a1de7..bfa746c5a7c8 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -443,7 +443,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @partition_align_bytes: alignment size for partition-able capacity
>   * @active_volatile_bytes: sum of hard + soft volatile
>   * @active_persistent_bytes: sum of hard + soft persistent
> - * @dcd_supported: all DCD commands are supported
> + * @dcd_enabled_cmds: DCD commands the device enabled in the CEL
>   * @event: event log driver state
>   * @poison: poison driver state info
>   * @security: security driver state info
> @@ -463,7 +463,7 @@ struct cxl_memdev_state {
>         u64 partition_align_bytes;
>         u64 active_volatile_bytes;
>         u64 active_persistent_bytes;
> -       bool dcd_supported;
> +       DECLARE_BITMAP(dcd_enabled_cmds, CXL_DCD_ENABLED_MAX);
> 
>         struct cxl_event_state event;
>         struct cxl_poison_state poison;
> @@ -878,12 +878,16 @@ int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> 
>  static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
>  {
> -       return mds->dcd_supported;
> +       /*
> +        * Disabled until extent event handling is implemented.  Enable by
> +        * returning bitmap_full(mds->dcd_enabled_cmds, CXL_DCD_ENABLED_MAX).
> +        */
> +       return false;
>  }
> 
>  static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
>  {
> -       mds->dcd_supported = false;
> +       bitmap_zero(mds->dcd_enabled_cmds, CXL_DCD_ENABLED_MAX);
>  }
> 
>  int cxl_set_timestamp(struct cxl_memdev_state *mds);
> 
> >  
> snip

