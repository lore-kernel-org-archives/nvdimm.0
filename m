From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation
 2
Date: Thu, 18 Aug 2016 21:26:48 +0000
Message-ID: <DM2PR21MB0089542D09455D6D5E3A38BACB150@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
 <CAPcyv4hXZ7V3Lh44zPw6Q_oGnjK_MOtPKNdeLbpHiRBVqBH3Qw@mail.gmail.com>
 <DM2PR21MB0089A226724184C8539DA669CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gBLhgPAHwchctm-DL6hjpNqx4mMpJdyXthR1SxH+5dwA@mail.gmail.com>
 <DM2PR21MB00898300C1E6F6761AC2ECD1CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gYODEgH+CjdL1JssVhCHf+-tTrxUxVSjd2inPcrisEKQ@mail.gmail.com>
 <DM2PR21MB00890E4AE41C24D9ACCEF56ACB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4hiUXFMQExYODQHD-gnAjDm27a2=Uh8N=HoNEiPoam5=A@mail.gmail.com>
 <DM2PR21MB0089B1DD11FCF8453E518678CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4i+vHXG30wBd+zjVrpyc8fCqy4g0cky=tASQRTuN5Vvhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4i+vHXG30wBd+zjVrpyc8fCqy4g0cky=tASQRTuN5Vvhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

Yes, but this actually *removes a bug* in the Linux kernel; if any memory resource is left to be set up later, it is currently not set up on x86 machines which don't have PCI busses.  That's not very many x86 systems, I'll agree, but I'm sure some enterprising person is busy creating an SoC which lacks PCI.

-----Original Message-----
From: Dan Williams [mailto:dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, August 18, 2016 4:17 PM
To: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Subject: Re: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation 2

On Thu, Aug 18, 2016 at 12:56 PM, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
> Compared to a patch which removes 5 lines of code, almost any additional work is ocean-boiling.
>

Did you check the state of NFIT enabling in Hyper-V?  Not patching the Linux kernel at all is even less work.
