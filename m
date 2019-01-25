Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190124231441.37A4A305@viggo.jf.intel.com> <20190124231448.E102D18E@viggo.jf.intel.com>
 <0852310e-41dc-dc96-2da5-11350f5adce6@oracle.com> <CAPcyv4hjJhUQpMy1CVJZur0Ssr7Cr2fkcD50L5gzx6v_KY14vg@mail.gmail.com>
 <5A90DA2E42F8AE43BC4A093BF067884825733A5B@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <5A90DA2E42F8AE43BC4A093BF067884825733A5B@SHSMSX104.ccr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Jan 2019 09:18:41 -0800
Message-ID: <CAPcyv4ikXD8rJAmV6tGNiq56m_ZXPZNrYkTwOSUJ7D1O_M5s=w@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal RAM
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: "Du, Fan" <fan.du@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying" <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcj9tZSBHbGlzc2U=?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, "Wu, Fengguang" <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 25, 2019 at 12:20 AM Du, Fan <fan.du@intel.com> wrote:
>
> Dan
>
> Thanks for the insights!
>
> Can I say, the UCE is delivered from h/w to OS in a single way in case of machine
> check, only PMEM/DAX stuff filter out UC address and managed in its own way by
> badblocks, if PMEM/DAX doesn't do so, then common RAS workflow will kick in,
> right?

The common RAS workflow always kicks in, it's just the page state
presented by a DAX mapping needs distinct handling. Once it is
hot-plugged it no longer needs to be treated differently than "System
RAM".

> And how about when ARS is involved but no machine check fired for the function
> of this patchset?

The hotplug effectively disconnects this address range from the ARS
results. They will still be reported in the libnvdimm "region" level
badblocks instance, but there's no safe / coordinated way to go clear
those errors without additional kernel enabling. There is no "clear
error" semantic for "System RAM".
