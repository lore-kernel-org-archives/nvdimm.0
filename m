Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22a.google.com (mail-lf0-x22a.google.com
 [IPv6:2a00:1450:4010:c07::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 480241A1DFA
 for <linux-nvdimm@lists.01.org>; Thu, 23 Jun 2016 11:06:28 -0700 (PDT)
Received: by mail-lf0-x22a.google.com with SMTP id q132so100950467lfe.3
 for <linux-nvdimm@lists.01.org>; Thu, 23 Jun 2016 11:05:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466702773.3504.363.camel@hpe.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
 <1466639694-25394-2-git-send-email-toshi.kani@hpe.com>
 <CACTTzNYAxtY-d8+8Vo=Y2WpuXVaSkJk9PC7DcHXKJuU=gqvXFw@mail.gmail.com>
 <1466702773.3504.363.camel@hpe.com>
From: Yigal Korman <yigal@plexistor.com>
Date: Thu, 23 Jun 2016 21:05:34 +0300
Message-ID: <CACTTzNY-sQYGGy-NhGP2hCUH2ynpDD-g74sJt4zY9c9RvGGFKw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] block: add QUEUE_FLAG_DAX for devices to advertise
 their DAX support
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 23, 2016 at 8:36 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Thu, 2016-06-23 at 19:31 +0300, Yigal Korman wrote:
>> On Thu, Jun 23, 2016 at 2:54 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
>> >
>> >
>> > Currently, presence of direct_access() in block_device_operations
>> > indicates support of DAX on its block device.  Because
>> > block_device_operations is instantiated with 'const', this DAX
>> > capablity may not be enabled conditinally.
>> >
>> > In preparation for supporting DAX to device-mapper devices, add
>> > QUEUE_FLAG_DAX to request_queue flags to advertise their DAX
>> > support.  This will allow to set the DAX capability based on how
>> > mapped device is composed.
>>
>> Hi Toshi,
>> This patch is very helpful!
>> I think QUEUE_FLAG_DAX can also help with identifying dax devices in
>> userspace.
>> Perhaps you'd be willing to squash the patch below with this one or
>> add it to your submission?
>
> Hi Yigal,
>
> Good idea.  Mike can probably take it into his tree, but I will include it
> into the series if I needed to submit v3.
>
> Acked-by: Toshi Kani <toshi.kani@hpe.com>

Great, Thanks!
I'll follow the thread to see if it goes through or needs to be resubmitted.

>
> I have one minor comment below.

My reply below as well.

>
>> [PATCH] block: expose QUEUE_FLAG_DAX in sysfs
>>
>> There's currently no way to identify DAX enabled devices in userspace.
>>
>> Signed-off-by: Yigal Korman <yigal@plexistor.com>
>> ---
>>  block/blk-sysfs.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index 9920596..d55126d 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -379,6 +379,15 @@ static ssize_t queue_wc_store(struct
>> request_queue *q, const char *page,
>>         return count;
>>  }
>>
>> +static ssize_t queue_dax_show(struct request_queue *q, char *page)
>> +{
>> +       int bit;
>> +
>> +       bit = test_bit(QUEUE_FLAG_DAX, &q->queue_flags);
>> +
>> +       return queue_var_show(bit, page);
>
> This can be:
>         return queue_var_show(blk_queue_dax(q), page);

Oh, sure, of course you're right. thanks.

Subject: [PATCH] block: expose QUEUE_FLAG_DAX in sysfs

There's currently no way to identify DAX enabled devices in userspace.

Signed-off-by: Yigal Korman <yigal@plexistor.com>
Acked-by: Toshi Kani <toshi.kani@hpe.com>
---
 block/blk-sysfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9920596..f87a7e7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -379,6 +379,11 @@ static ssize_t queue_wc_store(struct
request_queue *q, const char *page,
        return count;
 }

+static ssize_t queue_dax_show(struct request_queue *q, char *page)
+{
+       return queue_var_show(blk_queue_dax(q), page);
+}
+
 static struct queue_sysfs_entry queue_requests_entry = {
        .attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
        .show = queue_requests_show,
@@ -516,6 +521,11 @@ static struct queue_sysfs_entry queue_wc_entry = {
        .store = queue_wc_store,
 };

+static struct queue_sysfs_entry queue_dax_entry = {
+       .attr = {.name = "dax", .mode = S_IRUGO },
+       .show = queue_dax_show,
+};
+
 static struct attribute *default_attrs[] = {
        &queue_requests_entry.attr,
        &queue_ra_entry.attr,
@@ -542,6 +552,7 @@ static struct attribute *default_attrs[] = {
        &queue_random_entry.attr,
        &queue_poll_entry.attr,
        &queue_wc_entry.attr,
+       &queue_dax_entry.attr,
        NULL,
 };

--
1.9.3

Thanks,
Yigal

>
> Thanks,
> -Toshi
>
>> +}
>> +
>>  static struct queue_sysfs_entry queue_requests_entry = {
>>         .attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
>>         .show = queue_requests_show,
>> @@ -516,6 +525,11 @@ static struct queue_sysfs_entry queue_wc_entry = {
>>         .store = queue_wc_store,
>>  };
>>
>> +static struct queue_sysfs_entry queue_dax_entry = {
>> +       .attr = {.name = "dax", .mode = S_IRUGO },
>> +       .show = queue_dax_show,
>> +};
>> +
>>  static struct attribute *default_attrs[] = {
>>         &queue_requests_entry.attr,
>>         &queue_ra_entry.attr,
>> @@ -542,6 +556,7 @@ static struct attribute *default_attrs[] = {
>>         &queue_random_entry.attr,
>>         &queue_poll_entry.attr,
>>         &queue_wc_entry.attr,
>> +       &queue_dax_entry.attr,
>>         NULL,
>>  };
>>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
