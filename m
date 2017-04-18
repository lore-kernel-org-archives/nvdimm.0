Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF93821A6F106
 for <linux-nvdimm@lists.01.org>; Tue, 18 Apr 2017 16:16:16 -0700 (PDT)
Subject: Re: [PATCH] acpi, nfit: fix module unload vs workqueue shutdown race
References: <149253869300.4222.11825248275497461939.stgit@dwillia2-desk3.amr.corp.intel.com>
 <58F68D20.5090607@hpe.com>
 <CAPcyv4jGGiVGigQZMaXo_KfReEAJP=XgmD2GVbDW8hCLaF47Kg@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58F69E30.2040602@hpe.com>
Date: Tue, 18 Apr 2017 19:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jGGiVGigQZMaXo_KfReEAJP=XgmD2GVbDW8hCLaF47Kg@mail.gmail.com>
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/18/2017 07:05 PM, Dan Williams wrote:

>> It seems a bit better because I can sometimes get a test to complete
>> but then I'll get a panic when I try again.
> 
> Some forward progress... let me go back and try your test script on my
> bare metal config because this patch only addressed the reliable
> failure I was seeing for a single run of "make check".
> 
>> The footprints are the same
>> as before, sometimes when unloading the module but sometimes in a kfree
>> or related function.
>>
>> I'd be interested in your .config file and exactly how you're building
>> your bare metal kernel.
> 
> Here's the config and build + install steps I'm performing.
> 
> https://gist.github.com/djbw/73946ed4e8623aa1ded1b3615ba6d82b
> 

Thanks, I'll try your config.  There are quite a few differences,

-- ljk

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
