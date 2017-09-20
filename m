Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x234.google.com (mail-io0-x234.google.com
 [IPv6:2607:f8b0:4001:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 588DE21ECCB33
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 13:54:37 -0700 (PDT)
Received: by mail-io0-x234.google.com with SMTP id m103so6478817iod.13
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 13:57:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170920205328.GA2723@infradead.org>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
 <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
 <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
 <CAPcyv4hH5xU1qmD5vzCcDmcVNsM8CPQLAzd6DYWO1ezOeyV5Gg@mail.gmail.com>
 <20170920205328.GA2723@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Sep 2017 13:57:42 -0700
Message-ID: <CAPcyv4hBv6+q6CrtODYhY1pkhsWOnT+00C+LsQZf7NNPPXsSYQ@mail.gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>, Brian Stark <brian.stark@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 20, 2017 at 1:53 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Sep 20, 2017 at 09:52:32AM -0700, Dan Williams wrote:
>> What that means is that the utility to read the JEDEC registers would need to:
>>
>> 1/ Determine if the DIMM is standard JEDEC defined DIMM (the ACPI NFIT
>> should indicate this)
>>
>> 2/ Determine if the BIOS provides a DSM command family for the DIMM
>> that enables direct SMBUS commands.
>>
>> 3/ Craft the command in the proper format and send it to the Linux driver.
>
> if 1 and 2 are successfull shouldn't we have a bus driver for the
> in-kernel i2c subsystem that uses the dsm methods?  Those way both
> kernel clients for it, or userspace programs through /dev/i2c*
> could access it?

Makes sense to me.

The userspace command passthrough can get this going on any kernel,
but creating a generic i2c-bus seems useful for existing i2c clients.
The 2 solutions won't conflict since we have a global ASL interpreter
lock in the DSM path.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
