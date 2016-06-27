Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E9311A1E00
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 11:06:55 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id r2so211420854oih.2
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 11:06:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bd2353c0-0d84-3c0a-8117-3f24b823f469@hpe.com>
References: <146679026571.24395.11569929364936343871.stgit@dwillia2-desk3.amr.corp.intel.com>
 <bd2353c0-0d84-3c0a-8117-3f24b823f469@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Jun 2016 11:06:19 -0700
Message-ID: <CAPcyv4iELmJ9vDD7-juYOP4a6P51UFd49OUwreeofsXX7eHzCg@mail.gmail.com>
Subject: Re: [PATCH] acpi,
 nfit: fix acpi_check_dsm() vs zero functions implemented
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
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 27, 2016 at 10:40 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
> On 6/24/2016 1:44 PM, Dan Williams wrote:
>> QEMU 2.6 implements nascent support for nvdimm DSMs. Depending on
>> configuration it may only implement the function0 dsm to indicate that
>> no other DSMs are available. Commit 31eca76ba2fc "nfit, libnvdimm:
>> limited/whitelisted dimm command marshaling mechanism" breaks QEMU, but
>> QEMU is spec compliant.  Per the spec the way to indicate that no
>> functions are supported is:
>>
>>     If Function Index is zero, the return is a buffer containing one bit
>>     for each function index, starting with zero. Bit 0 indicates whether
>>     there is support for any functions other than function 0 for the
>>     specified UUID and Revision ID. If set to zero, no functions are
>>     supported (other than function zero) for the specified UUID and
>>     Revision ID.
>
> The rest of that paragraph is:
>
> If set to one, at least one additional function is supported. For all other bits
> in the buffer, a bit is set to zero to indicate if that function index is not
> supported for the specific UUID and Revision ID. (For example, bit 1 set to 0
> indicates that function index 1 is not supported for the specific UUID and
> Revision ID.)
>
>>
>> Update the nfit driver to determine the family (interface UUID) without
>> requiring the implementation to define any other functions, i.e.
>> short-circuit acpi_check_dsm() to succeed per the spec.  The nfit driver
>> appears to be the only user passing funcs==0 to acpi_check_dsm(), so
>> this behavior change of the common routine should be limited to the
>> probing done by the nfit driver.
>
> I don't understand why we're special casing this to support QEMU only when
> there are no DSM functions supported.  If we want to implement the
> spec and support function zero, I think we should support it correctly.
> That means returning the correct value for all spec compliant callers,
> even when there are functions that are supported.

QEMU 2.6 already shipped, so whatever we do we should not regress
those binaries.  The QEMU behavior could be argued as not spec
compliant, but they've implemented enough of function0 to answer the
"which family" probe. Yes, if an implementation supports function0 it
should say so in the returned bitmask, but by the time we've
determined that function0 is "not supported" we've already
successfully executed a function0 request.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
