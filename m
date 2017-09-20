Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DBF021E94602
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 19:39:40 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id b184so638576oii.13
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 19:42:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Sep 2017 19:42:44 -0700
Message-ID: <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 19, 2017 at 3:29 PM, Brian Stark <brian.stark@sanmina.com> wrote:
> Where can I find documentation on accessing NVDIMM JEDEC registers, for
> example if I want to read page 0 offset 0x80 (defined to be CSAVE_INFO in
> the JEDEC specification.  How do I do this through Linux given that the
> BIOS has locked the chipset?

Unless that register is mapped somewhere and the BIOS tells the OS how
to access it Linux can't get to it.  Does any of the methods defined
here retrieve the information you are looking for?

    https://msdn.microsoft.com/library/windows/hardware/mt604741
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
