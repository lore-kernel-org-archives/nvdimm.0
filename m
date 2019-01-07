Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com
 [IPv6:2607:f8b0:4864:20::334])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB353211AD36A
 for <linux-nvdimm@lists.01.org>; Mon,  7 Jan 2019 14:13:23 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id 81so1799557otj.2
 for <linux-nvdimm@lists.01.org>; Mon, 07 Jan 2019 14:13:23 -0800 (PST)
MIME-Version: 1.0
References: <1351778734.5719210.1546535622423.ref@mail.yahoo.com>
 <1351778734.5719210.1546535622423@mail.yahoo.com>
 <873fd52419a7561f983927597dfb6fb613fc937e.camel@intel.com>
 <69789157.5813313.1546545763506@mail.yahoo.com>
 <199cc2d719c01c7099723e3c5f4aaa88060535e1.camel@intel.com>
 <AT5PR8401MB1169B2838F6DB72BC62B308DAB8D0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <985533328.5906467.1546556529562@mail.yahoo.com>
 <AT5PR8401MB11699659E6B9E6EF513248C1AB8E0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <1210203101.7636183.1546896524417@mail.yahoo.com>
In-Reply-To: <1210203101.7636183.1546896524417@mail.yahoo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Jan 2019 14:13:11 -0800
Message-ID: <CAPcyv4giNsLO_c2fPmnhsQAetYSinuTMFKHFMoEo8cGYqCfU5A@mail.gmail.com>
Subject: Re: Question on Error Injection
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
To: Kamal Kakri <kamalkakri2017@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 7, 2019 at 1:28 PM Kamal Kakri <kamalkakri2017@yahoo.com> wrote:
>
>  Will it be OK to say that the behavior shall be same irrespective of if its load or store to a memory location with uncorrectable error (UCE) ?

No. Machine check exceptions occur on the consumption of poison (UCE),
stores don't consume poison.

> I see errors being reported at the granularity of blocks (badblock list). Is SIGBUS generated when the bad location is accessed or if the page (or block) having bad location is accessed?

SIGBUS is triggered preemptively if the kernel can determine that a
badblock exists in a page it is about to be faulted-in to the process.
It also triggers in the recovery path after a process has consumed
poison and the kernel was able to contain it by killing that affected
process.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
