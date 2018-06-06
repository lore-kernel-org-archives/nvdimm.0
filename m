Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DE202112B1CB
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 22:09:47 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl: add an api for getting ars_status flags
Date: Wed, 6 Jun 2018 05:09:45 +0000
Message-ID: <1528261783.5328.23.camel@intel.com>
References: <20180606000034.12161-1-vishal.l.verma@intel.com>
 <CAPcyv4g_1hNzqJA9g3c_TtXCaK72teY6QLH42xcwHx+dwfXb3w@mail.gmail.com>
In-Reply-To: <CAPcyv4g_1hNzqJA9g3c_TtXCaK72teY6QLH42xcwHx+dwfXb3w@mail.gmail.com>
Content-Language: en-US
Content-ID: <B50067EBB309B346A632CE0EB8CBF108@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Zloch, Jacek" <jacek.zloch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-06-05 at 19:07 -0700, Dan Williams wrote:
> On Tue, Jun 5, 2018 at 5:00 PM, Vishal Verma <vishal.l.verma@intel.com>
> wrote:
> > The ARS status command defines a 'flags' field that wasn't being
> > exposed
> > via an API yet. Add a new ndctl_cmd_ars_get_flags() helper to retrieve
> > this field.
> > 
> > Reported-by: Jacek Zloch <jacek.zloch@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> I'm wondering if we should add a 'get' routine for each flag value as
> to not expose the binary representation of the flags in case they ever
> change. The hope is that if some other platform added their own
> ARS-like facility that we would be able to reuse these routines and
> translate between ACPI and a theoretical Open Firmware implementation,
> for example.

Yes that makes sense, I'll routines for all the flags we have today.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
