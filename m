Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72FEE211BA456
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 10:20:58 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like
 normal RAM
Date: Fri, 25 Jan 2019 18:20:56 +0000
Message-ID: <b7d45d83a314955e7dff25401dfc0d4f4247cfcd.camel@intel.com>
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <0852310e-41dc-dc96-2da5-11350f5adce6@oracle.com>
 <CAPcyv4hjJhUQpMy1CVJZur0Ssr7Cr2fkcD50L5gzx6v_KY14vg@mail.gmail.com>
 <5A90DA2E42F8AE43BC4A093BF067884825733A5B@SHSMSX104.ccr.corp.intel.com>
 <CAPcyv4ikXD8rJAmV6tGNiq56m_ZXPZNrYkTwOSUJ7D1O_M5s=w@mail.gmail.com>
In-Reply-To: <CAPcyv4ikXD8rJAmV6tGNiq56m_ZXPZNrYkTwOSUJ7D1O_M5s=w@mail.gmail.com>
Content-Language: en-US
Content-ID: <54E31B413D1FF149BE238966A26CD136@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Du, Fan" <fan.du@intel.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "mhocko@suse.com" <mhocko@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Huang,  Ying  <ying.huang@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "Wu, Fengguang  <fengguang.wu@intel.com>, baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-01-25 at 09:18 -0800, Dan Williams wrote:
> On Fri, Jan 25, 2019 at 12:20 AM Du, Fan <fan.du@intel.com> wrote:
> > Dan
> > 
> > Thanks for the insights!
> > 
> > Can I say, the UCE is delivered from h/w to OS in a single way in
> > case of machine
> > check, only PMEM/DAX stuff filter out UC address and managed in its
> > own way by
> > badblocks, if PMEM/DAX doesn't do so, then common RAS workflow will
> > kick in,
> > right?
> 
> The common RAS workflow always kicks in, it's just the page state
> presented by a DAX mapping needs distinct handling. Once it is
> hot-plugged it no longer needs to be treated differently than "System
> RAM".
> 
> > And how about when ARS is involved but no machine check fired for
> > the function
> > of this patchset?
> 
> The hotplug effectively disconnects this address range from the ARS
> results. They will still be reported in the libnvdimm "region" level
> badblocks instance, but there's no safe / coordinated way to go clear
> those errors without additional kernel enabling. There is no "clear
> error" semantic for "System RAM".
> 
Perhaps as future enabling, the kernel can go perform "clear error" for
offlined pages, and make them usable again. But I'm not sure how
prepared mm is to re-accept pages previously offlined.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
