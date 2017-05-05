Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x235.google.com (mail-io0-x235.google.com
 [IPv6:2607:f8b0:4001:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3147521A1348A
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 12:33:06 -0700 (PDT)
Received: by mail-io0-x235.google.com with SMTP id f102so20253684ioi.2
 for <linux-nvdimm@lists.01.org>; Fri, 05 May 2017 12:33:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j0DKBBfjybWmkqNByJqL4VA_fw-0myLggBYiScvkMc2g@mail.gmail.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454140.2642.16610436149753296619.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4j0DKBBfjybWmkqNByJqL4VA_fw-0myLggBYiScvkMc2g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 May 2017 12:33:04 -0700
Message-ID: <CAPcyv4gV064My_q5eq=LqBrQg_c3PiJVpcUd1uKBnxS6SRnW=g@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] ndctl: add clear-error to ndctl for device dax
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 5, 2017 at 12:14 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, May 4, 2017 at 2:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>> Adding ndctl support that will allow clearing of bad blocks for a device.
>> Initial implementation will only support device dax devices. The ndctl
>> takes a device path and parameters of the starting bad block, and the number
>> of bad blocks to clear.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  Documentation/ndctl-clear-error.txt |   38 ++++++
>>  builtin.h                           |    1
>>  ndctl/Makefile.am                   |    1
>>  ndctl/clear-error.c                 |  239 +++++++++++++++++++++++++++++++++++
>>  ndctl/lib/libndctl.c                |   72 +++++++++++
>>  ndctl/lib/libndctl.sym              |    2
>>  ndctl/libndctl.h.in                 |   10 +
>>  ndctl/ndctl.c                       |    1
>>  8 files changed, 364 insertions(+)
>>  create mode 100644 Documentation/ndctl-clear-error.txt
>>  create mode 100644 ndctl/clear-error.c
>>
>> diff --git a/Documentation/ndctl-clear-error.txt b/Documentation/ndctl-clear-error.txt
>> new file mode 100644
>> index 0000000..b14521a
>> --- /dev/null
>> +++ b/Documentation/ndctl-clear-error.txt
>> @@ -0,0 +1,38 @@
>> +ndctl-clear-error(1)
>> +====================
>> +
>> +NAME
>> +----
>> +ndctl-clear-error - clear badblocks for a device
>
> I think "clear-error" is too ambiguous of a name, lets call the
> commands repair-media-errors and list-media-errors.

Actually let's kill the separate 'list-media-errors' command and just
add it as optional output to our existing 'list' command. With that in
place the repair command can be shortened to "repair-media"
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
