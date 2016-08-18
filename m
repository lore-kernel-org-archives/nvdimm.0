From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation
 2
Date: Thu, 18 Aug 2016 19:56:26 +0000
Message-ID: <DM2PR21MB0089B1DD11FCF8453E518678CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
 <CAPcyv4hXZ7V3Lh44zPw6Q_oGnjK_MOtPKNdeLbpHiRBVqBH3Qw@mail.gmail.com>
 <DM2PR21MB0089A226724184C8539DA669CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gBLhgPAHwchctm-DL6hjpNqx4mMpJdyXthR1SxH+5dwA@mail.gmail.com>
 <DM2PR21MB00898300C1E6F6761AC2ECD1CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gYODEgH+CjdL1JssVhCHf+-tTrxUxVSjd2inPcrisEKQ@mail.gmail.com>
 <DM2PR21MB00890E4AE41C24D9ACCEF56ACB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4hiUXFMQExYODQHD-gnAjDm27a2=Uh8N=HoNEiPoam5=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hiUXFMQExYODQHD-gnAjDm27a2=Uh8N=HoNEiPoam5=A@mail.gmail.com>
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
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Compared to a patch which removes 5 lines of code, almost any additional work is ocean-boiling.

-----Original Message-----
From: Dan Williams [mailto:dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, August 18, 2016 3:12 PM
To: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Subject: Re: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation 2

On Thu, Aug 18, 2016 at 11:26 AM, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
> *Until* such a mechanism is in, I see no reason to not keep feature parity for all platforms.  This is the exact "You should boil the ocean" response that Arjan famously complained about at Kernel Summit a few years ago.

Feature parity for all platforms is the NFIT which Hyper-V is already implementing.

Setting that aside, if we want to fix memmap= for the general case, implementing a table like mBFT does not amount to ocean boiling in my opinion.
