From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation
 2
Date: Thu, 18 Aug 2016 18:26:17 +0000
Message-ID: <DM2PR21MB00890E4AE41C24D9ACCEF56ACB150@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
 <CAPcyv4hXZ7V3Lh44zPw6Q_oGnjK_MOtPKNdeLbpHiRBVqBH3Qw@mail.gmail.com>
 <DM2PR21MB0089A226724184C8539DA669CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gBLhgPAHwchctm-DL6hjpNqx4mMpJdyXthR1SxH+5dwA@mail.gmail.com>
 <DM2PR21MB00898300C1E6F6761AC2ECD1CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gYODEgH+CjdL1JssVhCHf+-tTrxUxVSjd2inPcrisEKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gYODEgH+CjdL1JssVhCHf+-tTrxUxVSjd2inPcrisEKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

*Until* such a mechanism is in, I see no reason to not keep feature parity for all platforms.  This is the exact "You should boil the ocean" response that Arjan famously complained about at Kernel Summit a few years ago.

-----Original Message-----
From: Dan Williams [mailto:dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, August 18, 2016 2:15 PM
To: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>; X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Subject: Re: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation 2

On Thu, Aug 18, 2016 at 11:05 AM, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
> I'd rather the memmap= option works on all platforms.  Unless we're going to get rid of it entirely and exclusively use ACPI tables, I see no good reason to leave this landmine lying around for someone else to blow their own leg off.
>

memmap= is already a landmine: https://lkml.org/lkml/2016/6/28/819

Killing memmap= in favor of NFIT is a better way to go.  I chatted with Peter off list about this problem and he wondered about re-purposing using the mBFT mechanism to define memory ranges:

http://omniboot.org/txt/syslinux/memdisk.txt
