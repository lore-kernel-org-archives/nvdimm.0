Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED0AC21E47D58
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 09:50:02 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id j144so7136733oib.1
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 09:52:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170823164714.GC25999@linux.intel.com>
References: <150344672033.39111.1745886872895468624.stgit@djiang5-desk3.ch.intel.com>
 <20170823164714.GC25999@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Aug 2017 09:52:35 -0700
Message-ID: <CAPcyv4gP=if_TXqvWcZaRD+M+UhKjp3jqMkfsC_S1-r22zNfnA@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl: daxctl: Adding io option for daxctl
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 23, 2017 at 9:47 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Aug 22, 2017 at 05:06:15PM -0700, Dave Jiang wrote:
>> The daxctl io option allows I/Os to be performed between file descriptor to
>> and from device dax files. It also provides a way to zero a device dax
>> device.
>>
>> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>
>> v2:
>> - Removed dependency on ndctl to match device and address other comments
>> by Dan.
>>
>>  Documentation/daxctl/Makefile.am   |    3 +-
>>  Documentation/daxctl/daxctl-io.txt |   70 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 72 insertions(+), 1 deletion(-)
>>  create mode 100644 Documentation/daxctl/daxctl-io.txt
>>
>> diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
>> index 5913c94..032d48c 100644
>> --- a/Documentation/daxctl/Makefile.am
>> +++ b/Documentation/daxctl/Makefile.am
>> @@ -16,7 +16,8 @@ asciidoc.conf: ../asciidoc.conf.in
>>
>>  man1_MANS = \
>>       daxctl.1 \
>> -     daxctl-list.1
>> +     daxctl-list.1 \
>> +     daxctl-io.1
>>
>>  CLEANFILES = $(man1_MANS)
>>
>> diff --git a/Documentation/daxctl/daxctl-io.txt b/Documentation/daxctl/daxctl-io.txt
>> new file mode 100644
>> index 0000000..a7acc9e
>> --- /dev/null
>> +++ b/Documentation/daxctl/daxctl-io.txt
>> @@ -0,0 +1,70 @@
>> +daxctl-io(1)
>> +===========
>> +
>> +NAME
>> +----
>> +daxctl-io - Perform I/O on Device-DAX devices or zero a Device-DAX device.
>> +
>> +SYNOPSIS
>> +--------
>> +[verse]
>> +'daxctl io' [<options>]
>> +
>> +There must be a Device-DAX device involved whether as the input or the output
>> +device. Read from a Device-DAX device and write to a file descriptor, or
>> +another Device-DAX device. Write to a Device-DAX device from a file descriptor
>> +or another Device-DAX device.
>> +
>> +No length specified will default to input file/device length. If input is
>> +a special char file then length will be the output file/device length.
>> +
>> +No input will default to stdin. No output will default to stdout.
>> +
>> +For a Device-DAX device, attempts to clear badblocks within range of writes
>> +will be performed.
>> +
>> +EXAMPLE
>> +-------
>> +[verse]
>> +# daxctl io --zero /dev/dax1.0
>> +
>> +# daxctl io --input=/dev/dax1.0 --output=/home/myfile --len=2097152 --seek=4096
>
> Do you have plans to add support for suffixes so people don't have to do
> --len=2097152 or --len=$((2*1024*1024))?

Good eye, this command should be using the same size parsing scheme as
ndctl create-namepace. See parse_size64()...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
