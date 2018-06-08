Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC430210E4352
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 07:24:52 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH 3/5] hw/i386: Update SSDT table used by
 "make check"
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-3-ross.zwisler@linux.intel.com>
 <20180608021134-mutt-send-email-mst@kernel.org>
From: Eric Blake <eblake@redhat.com>
Message-ID: <5b2dafa6-1206-bef3-10d7-eac9910baa85@redhat.com>
Date: Fri, 8 Jun 2018 09:24:49 -0500
MIME-Version: 1.0
In-Reply-To: <20180608021134-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Cornelia Huck <cohuck@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 06/07/2018 06:14 PM, Michael S. Tsirkin wrote:
> On Thu, Jun 07, 2018 at 04:31:09PM -0600, Ross Zwisler wrote:
>> This commit:
>>
>> commit aa78a16d8645 ("hw/i386: Rename 2.13 machine types to 3.0")
>>
>> updated the name used to create the q35 machine, which in turn changed the
>> SSDT table which is generated when we run "make check":
>>
>>    acpi-test: Warning! SSDT mismatch. Actual [asl:/tmp/asl-QZDWJZ.dsl,
>>    aml:/tmp/aml-T8JYJZ], Expected [asl:/tmp/asl-DTWVJZ.dsl,
>>    aml:tests/acpi-test-data/q35/SSDT.dimmpxm].
>>
>> Here's the only difference, aside from the checksum:
>>
>>    <     Name (MEMA, 0x07FFF000)
>>    ---
>>    >     Name (MEMA, 0x07FFE000)
> 
> Weird. How come the phys address changes just because of machine name?

"2.13" is a different length than "3.0"; depending on whatever other 
alignment coincidences or sharing of similar substrings are in place, 
this obviously shuffled enough data that the one byte change then 
reflects into an entire page boundary difference.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
