Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01on0700.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe41::700])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0295E820D1
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 10:02:21 -0800 (PST)
Subject: Re: [PATCH 3/3] Remove unnecessary newline
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <057ada9967af9e029d2d32cef87b5ab87db4de47.1486750247.git.linda.knippers@hpe.com>
 <CAPcyv4h6qKU8jSFCDwsf2UyeOL0R_2RfKU=eUETMb0mOjZeOwA@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58A1F4A7.9030007@hpe.com>
Date: Mon, 13 Feb 2017 13:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h6qKU8jSFCDwsf2UyeOL0R_2RfKU=eUETMb0mOjZeOwA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 02/13/2017 12:32 PM, Dan Williams wrote:
> On Mon, Feb 13, 2017 at 8:27 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> Newline in MODULE_PARM_DESC messes up the modprobe output so remove it.
> 
> Yes, looks good. When this "messes up" does that mean the output less
> pretty, or do you know if it breaks scripts parsing the output? Just
> want to be clear on the effects of this change.

If you do a 'modinfo nfit', it puts "(bool)" on a separate line.
That's unlike all the other parameters.  If someone is parsing the output
of modinfo, they may not get the type.

Without my patch, you get this:

parm:           force_enable_dimms:Ignore _STA (ACPI DIMM device) status (bool)
parm:           scrub_timeout:Initial scrub timeout in seconds (uint)
parm:           scrub_overflow_abort:Number of times we overflow ARS results before abort (uint)
parm:           disable_vendor_specific:Limit commands to the publicly specified set
(bool)
parm:           default_dsm_family:Try this DSM type first when identifying NVDIMM family (int)

instead of this:

parm:           force_enable_dimms:Ignore _STA (ACPI DIMM device) status (bool)
parm:           scrub_timeout:Initial scrub timeout in seconds (uint)
parm:           scrub_overflow_abort:Number of times we overflow ARS results before abort (uint)
parm:           disable_vendor_specific:Limit commands to the publicly specified set (bool)
parm:           default_dsm_family:Try this DSM type first when identifying NVDIMM family (int)


-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
