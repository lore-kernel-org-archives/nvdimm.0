From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation
 2
Date: Thu, 18 Aug 2016 17:50:01 +0000
Message-ID: <DM2PR21MB0089A226724184C8539DA669CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
 <CAPcyv4hXZ7V3Lh44zPw6Q_oGnjK_MOtPKNdeLbpHiRBVqBH3Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hXZ7V3Lh44zPw6Q_oGnjK_MOtPKNdeLbpHiRBVqBH3Qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

This is the memmap= kernel command line option.

-----Original Message-----
From: Dan Williams [mailto:dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, August 18, 2016 1:32 PM
To: Matthew Wilcox <mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation 2

Is this for the memmap= kernel command line option or the ACPI NFIT
method for defining NVDIMM resources?
