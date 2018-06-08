Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E59621144CE8
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 11:01:35 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH 4/5] machine: fix some misspelled words
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-4-ross.zwisler@linux.intel.com>
 <17f8856c-48d9-d112-cd7f-e1b3679d2f43@redhat.com>
 <20180608174114.GA30678@linux.intel.com>
From: Eric Blake <eblake@redhat.com>
Message-ID: <480726b0-4a0a-9287-0378-6716b2a196f8@redhat.com>
Date: Fri, 8 Jun 2018 13:01:26 -0500
MIME-Version: 1.0
In-Reply-To: <20180608174114.GA30678@linux.intel.com>
Content-Language: en-US
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Huth <thuth@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 06/08/2018 12:41 PM, Ross Zwisler wrote:

>>> -        "Set on/off to enable/disable igd passthrou", &error_abort);
>>> +        "Set on/off to enable/disable igd passthru", &error_abort);
>>
>> Shouldn't that rather be "passthrough" instead?
> 
> Either works, I think.  "thru" and "passthru" are short informal versions of
> "through" and "passthrough", but both the long and short versions of both
> words are used all over the QEMU source.  "passthrou" is clearly wrong.  If
> the longer version is preferred in this case please feel free to fix up when
> you apply.

"passthru" is fine as an abbreviation in source code (and gcc 
understands it).  But in English text presented to the end user, as is 
the case here, you should use the correct spelling "passthrough", and 
not an abbreviation.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
