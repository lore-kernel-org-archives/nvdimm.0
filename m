Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF62C1A1DF9
 for <linux-nvdimm@lists.01.org>; Mon,  8 Aug 2016 12:36:31 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id c15so27735502oig.0
 for <linux-nvdimm@lists.01.org>; Mon, 08 Aug 2016 12:36:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160808191019.GA965@linux.intel.com>
References: <20160729205912.20436-1-ross.zwisler@linux.intel.com>
 <20160802182653.6647-1-ross.zwisler@linux.intel.com>
 <20160808191019.GA965@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 Aug 2016 12:36:30 -0700
Message-ID: <CAPcyv4jr4KSsVn-CgJmqYXqcZ=Rah9UP025x-4Uv2rz8S0JW=Q@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, nd_blk: mask off reserved status bits
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Lee, Chun-Yi  <jlee@suse.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown" <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 8, 2016 at 12:10 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Aug 02, 2016 at 12:26:53PM -0600, Ross Zwisler wrote:
>> The "NVDIMM Block Window Driver Writer's Guide":
>>
>> http://pmem.io/documents/
>> http://pmem.io/documents/NVDIMM_DriverWritersGuide-July-2016.pdf
>>
>> defines the layout of the block window status register.  For the July 2016
>> version of the spec linked to above, this happens in Figure 4 on page 26.
>>
>> The only bits defined in this spec are bits 31, 5, 4, 2, 1 and 0.  The rest
>> of the bits in the status register are reserved, and there is a warning
>> following the diagram that says:
>>
>>   Note: The driver cannot assume the value of the RESERVED bits in the
>>   status register are zero. These reserved bits need to be masked off, and
>>   the driver must avoid checking the state of those bits.
>>
>> This change ensures that for hardware implementations that set these
>> reserved bits in the status register, the driver won't incorrectly fail the
>> block I/Os.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: stable@vger.kernel.org # v4.2+
>
> Ping on this patch - through which tree should we merge this for v4.8-rc2?
> Dan's nvdimm tree?

It's getting 0-day coverage on my libnvdimm-pending branch and will go
to Linus at the end of the week.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
