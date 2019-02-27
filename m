Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DAF921B02822
 for <linux-nvdimm@lists.01.org>; Wed, 27 Feb 2019 14:51:32 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v4] nvdimm, btt: fix LBA masking during 'free list'
 population
Date: Wed, 27 Feb 2019 22:51:29 +0000
Message-ID: <0eb9fcc61684d79311fee81582b4a448da149a25.camel@intel.com>
References: <CAPcyv4g_FJkDa+0M9p-JwkwLLCkSr=NEw=-GAYnJ0NDD7Sbk2g@mail.gmail.com>
 <20190226231331.8730-1-vishal.l.verma@intel.com>
 <PU1P153MB01693156DE97BEA6BF300ACBBF740@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <34fc552cb992d62e14b4edda8edc1534b32277b4.camel@intel.com>
 <PU1P153MB0169CE8A3E100756A18CBC5ABF740@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169CE8A3E100756A18CBC5ABF740@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <176293081ED82A40B40D31E5B372013A@intel.com>
MIME-Version: 1.0
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
To: "decui@microsoft.com" <decui@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "pbarbuda@microsoft.com" <pbarbuda@microsoft.com>, "mikelley@microsoft.com" <mikelley@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-02-27 at 21:06 +0000, Dexuan Cui wrote:
> > From: Verma, Vishal L <vishal.l.verma@intel.com>
> > Sent: Wednesday, February 27, 2019 10:13 AM
> > ...
> > > I suppose the new line should not be added, and the line
> > >   		if (ent_e_flag(log_new.old_map)) {
> > > should be changed to
> > >   		if (ent_e_flag(log_new.old_map) && !
> > ent_z_flag(log_new.old_map)) {
> > > ?
> > > 
> > Ah yes good catch, I broke my own rule, in that freelist[i].block should
> > not have flag bits since it is used as is. The freelist has a separate
> > has_err field to allow for error clearing, and we should be setting
> > that.
> > 
> > Does the following incremental patch fix it? Let me know and I can send
> > a new version including it.
> 
> Yes, the patch works for me. Thank you!
> 
> But, should we really set the has_err field? Here the enry has both
> the zere/error flags set. As I understand, this is not an error, because
> the UEFI spec says "... both Error and Zero are set to indicate a map entry
> in its normal, non-error state".
>  
Ah yes I see what you mean - we'd be pointlessly trying to clear those
blocks. I'll fix this in v5.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
