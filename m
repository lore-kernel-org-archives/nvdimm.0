Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 115392095D217
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 08:57:39 -0700 (PDT)
Subject: Re: Standardization of ACPI NVDIMM DSMs
References: <20170628094025.00001fc0@bluestop.org>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <9f16559d-fc0f-ad0d-2c13-1fc0b38aa733@hpe.com>
Date: Wed, 28 Jun 2017 11:59:04 -0400
MIME-Version: 1.0
In-Reply-To: <20170628094025.00001fc0@bluestop.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Rebecca Cran <rebecca@bluestop.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/28/2017 11:40 AM, Rebecca Cran wrote:
> I'm pretty new to ACPI work so it's possibly I'm misunderstanding
> something. I've recently started working on NVDIMMs, and have
> noticed that both HPE and Intel have DSM "Example" interfaces that are
> referenced/used in Linux. I've been wondering if there's a reason
> the content from both couldn't be combined and added to the ACPI
> specification with sufficient vendor-specific fields to support the
> cases where they need to differ?

Hi Rebecca,

The main reason that there are multiple specifications, including
yet another from Microsoft, is that different hardware is evolving
in parallel and there are some different needs.  However, there is
a big effort to standardize as much as possible.  If you compare
ACPI 6.1 to ACPI 6.2, you can see new root device DSMs as well as
standard methods for reading/writing label space.  These replace
what were previously vendor-specific functions.

There is more standardization that will likely happen.  The most
interesting is probably standard health status information.  Today
the Linux ndctl command can display health status for the NVDIMMs
and it hides some of the differences by calling the appropriate
DSM for the platform/NVDIMM combination but we need to do more
work there.

Does this help?

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
