Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF9C521A6F106
 for <linux-nvdimm@lists.01.org>; Tue, 18 Apr 2017 16:05:57 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id x184so9231856oia.1
 for <linux-nvdimm@lists.01.org>; Tue, 18 Apr 2017 16:05:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58F68D20.5090607@hpe.com>
References: <149253869300.4222.11825248275497461939.stgit@dwillia2-desk3.amr.corp.intel.com>
 <58F68D20.5090607@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Apr 2017 16:05:56 -0700
Message-ID: <CAPcyv4jGGiVGigQZMaXo_KfReEAJP=XgmD2GVbDW8hCLaF47Kg@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: fix module unload vs workqueue shutdown race
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 18, 2017 at 3:03 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 04/18/2017 02:06 PM, Dan Williams wrote:
>> The workqueue may still be running when the devres callbacks start
>> firing to deallocate an acpi_nfit_desc instance. Stop and flush the
>> workqueue before letting any other devres de-allocations proceed.
>>
>> Reported-by: Linda Knippers <linda.knippers@hpe.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>
>> I was able to produce a reliable nfit_test crash failure by running the
>> tests on hardware *and* disabling all debug messages. That last detail
>> may be why I have been seeing much less frequent failures. With this
>> change, in addition to the previous fix [1], I was again able to
>> complete a successful run.
>
> It seems a bit better because I can sometimes get a test to complete
> but then I'll get a panic when I try again.

Some forward progress... let me go back and try your test script on my
bare metal config because this patch only addressed the reliable
failure I was seeing for a single run of "make check".

> The footprints are the same
> as before, sometimes when unloading the module but sometimes in a kfree
> or related function.
>
> I'd be interested in your .config file and exactly how you're building
> your bare metal kernel.

Here's the config and build + install steps I'm performing.

https://gist.github.com/djbw/73946ed4e8623aa1ded1b3615ba6d82b
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
