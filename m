Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81E4D21A07A82
 for <linux-nvdimm@lists.01.org>; Wed,  7 Nov 2018 13:26:28 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm: Fix __nd_ioctl() to check error in cmd_rc
Date: Wed, 7 Nov 2018 21:26:23 +0000
Message-ID: <c5ef03e6652130a2a548511074b824cf7e25100d.camel@hpe.com>
References: <20181107185241.26982-1-toshi.kani@hpe.com>
 <CAPcyv4hE49JiFdaM_L0+KPQayZ0qRYokNRPxD5YuwCCp4fzkqQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hE49JiFdaM_L0+KPQayZ0qRYokNRPxD5YuwCCp4fzkqQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <5B23673BCFE56C4083813217C85D7534@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-11-07 at 11:34 -0800, Dan Williams wrote:
> On Wed, Nov 7, 2018 at 10:52 AM Toshi Kani <toshi.kani@hpe.com> wrote:
> > 
> > ndctl zero-labels completes with a large number of zeroed nmems when
> > it fails to do zeroing on a protected NVDIMM.
> > 
> >   # ndctl zero-labels nmem1
> >   zeroed 65504 nmems
> > 
> > When an ACPI call completes with error, xlat_status() called from
> > acpi_nfit_ctl() sets error to *cmd_rc.  __nd_ioctl(), however, does
> > not check this error and returns with success.
> > 
> > Fix __nd_ioctl() to check this error in cmd_rc.
> 
> So this arrangement is by design and the bug is in the ndctl utility.
> 
> A successful return code from the ioctl means that the command was
> successfully submitted to firmware. It's then up to userspace to parse
> if there was a command specific error returned in the response
> payload. Automatically returning cmd_rc removes the ability for
> userspace tooling to do its own command specific error handling. With
> this change userspace could no longer be sure if the failure is in the
> submission or the execution of the command, or determine if the
> command response payload is valid.

I see.  I was wondering which side needs to be fixed, and decided to
follow kernel-internal ACPI calls like nvdimm_clear_poison().  I agree
that a command error code is necessary if user space tool needs to deal
with it.  OK, I will look into fixing ndctl.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
