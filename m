Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D7D6211BA456
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 11:15:20 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id u16so9512592otk.8
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 11:15:20 -0800 (PST)
MIME-Version: 1.0
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <0852310e-41dc-dc96-2da5-11350f5adce6@oracle.com>
 <CAPcyv4hjJhUQpMy1CVJZur0Ssr7Cr2fkcD50L5gzx6v_KY14vg@mail.gmail.com>
 <5A90DA2E42F8AE43BC4A093BF067884825733A5B@SHSMSX104.ccr.corp.intel.com>
 <CAPcyv4ikXD8rJAmV6tGNiq56m_ZXPZNrYkTwOSUJ7D1O_M5s=w@mail.gmail.com>
 <b7d45d83a314955e7dff25401dfc0d4f4247cfcd.camel@intel.com>
 <dc7d8190-2c94-9bdb-fb5b-a80a3fb55822@oracle.com>
In-Reply-To: <dc7d8190-2c94-9bdb-fb5b-a80a3fb55822@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Jan 2019 11:15:08 -0800
Message-ID: <CAPcyv4hEyG-1hC=20M7YGFG-BF7yvNcG7EkLurAfysHHB2yXBA@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
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
To: Jane Chu <jane.chu@oracle.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Wu, Fengguang  <fengguang.wu@intel.com>, dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>, "Huang, Ying" <ying.huang@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "mhocko@suse.com" <mhocko@suse.com>, "baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 25, 2019 at 11:10 AM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 1/25/2019 10:20 AM, Verma, Vishal L wrote:
> >
> > On Fri, 2019-01-25 at 09:18 -0800, Dan Williams wrote:
> >> On Fri, Jan 25, 2019 at 12:20 AM Du, Fan <fan.du@intel.com> wrote:
> >>> Dan
> >>>
> >>> Thanks for the insights!
> >>>
> >>> Can I say, the UCE is delivered from h/w to OS in a single way in
> >>> case of machine
> >>> check, only PMEM/DAX stuff filter out UC address and managed in its
> >>> own way by
> >>> badblocks, if PMEM/DAX doesn't do so, then common RAS workflow will
> >>> kick in,
> >>> right?
> >>
> >> The common RAS workflow always kicks in, it's just the page state
> >> presented by a DAX mapping needs distinct handling. Once it is
> >> hot-plugged it no longer needs to be treated differently than "System
> >> RAM".
> >>
> >>> And how about when ARS is involved but no machine check fired for
> >>> the function
> >>> of this patchset?
> >>
> >> The hotplug effectively disconnects this address range from the ARS
> >> results. They will still be reported in the libnvdimm "region" level
> >> badblocks instance, but there's no safe / coordinated way to go clear
> >> those errors without additional kernel enabling. There is no "clear
> >> error" semantic for "System RAM".
> >>
> > Perhaps as future enabling, the kernel can go perform "clear error" for
> > offlined pages, and make them usable again. But I'm not sure how
> > prepared mm is to re-accept pages previously offlined.
> >
>
> Offlining a DRAM backed page due to an UC makes sense because
>   a. the physical DRAM cell might still have an error
>   b. power cycle, scrubing could potentially 'repair' the DRAM cell,
> making the page usable again.
>
> But for a PMEM backed page, neither is true. If a poison bit is set in
> a page, that indicates the underlying hardware has completed the repair
> work, all that's left is for software to recover.  Secondly, because
> poison is persistent, unless software explicitly clear the bit,
> the page is permanently unusable.

Not permanently... system-owner always has the option to use the
device-DAX and ARS mechanisms to clear errors at the next boot.
There's just no kernel enabling to do that automatically as a part of
this patch set.

However, we should consider this along with the userspace enabling to
control which device-dax instances are set aside for hotplug. It would
make sense to have a "clear errors before hotplug" configuration
option.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
