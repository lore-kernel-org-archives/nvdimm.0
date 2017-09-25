Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A301420945BC5
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 09:32:51 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id b184so7796477oii.13
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 09:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKccVaxR7a2cFAZA7MHEjX6f1CNLxeikf-24XheMkxc9Nh58pg@mail.gmail.com>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
 <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
 <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
 <AT5PR84MB008227F060E36A2AF273952EAB610@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4iM-LMDFkCAPJyFNyDF21ywHwsn90kpB9Eezub_7D-_Tw@mail.gmail.com>
 <CAKccVaxR7a2cFAZA7MHEjX6f1CNLxeikf-24XheMkxc9Nh58pg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Sep 2017 09:36:01 -0700
Message-ID: <CAPcyv4hZhy0EOiMxtBV-L6qQbsu8XHPMBW9EUF0cnaL2w4sefw@mail.gmail.com>
Subject: Re: Access to NVDIMM JEDEC registers
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
To: Brian Stark <brian.stark@sanmina.com>
Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 25, 2017 at 9:16 AM, Brian Stark <brian.stark@sanmina.com> wrote:
> Really I am just trying to understand what is currently implemented.   If
> you take away the direct access functions I mention, the rest of the
> functions should provide most functionality needed but implementing many of
> those functions will require that they have access to the SMBUS controller.
> It might be helpful to know what functions in the DSM interface have been
> deployed and what kernel they are available in.

All the DSM functions I have pointed you to are enabled in the kernel
since v4.8. What Robert is saying is that even if the kernel supports
the command the platform BIOS may disable those commands outside of
special debug BIOS images.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
