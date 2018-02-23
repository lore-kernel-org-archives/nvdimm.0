Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x242.google.com (mail-lf0-x242.google.com
 [IPv6:2a00:1450:4010:c07::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7359920954CB7
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:39:41 -0800 (PST)
Received: by mail-lf0-x242.google.com with SMTP id r80so14316548lfe.13
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:45:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180223205851.GB7750@linux.intel.com>
References: <151936916209.18166.8915957818264326430.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180223205851.GB7750@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Feb 2018 13:45:40 -0800
Message-ID: <CAPcyv4izYKJ4=qxg5rGx4KOnpyb+8TakJK-ZfoEPnNV37GBF9w@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl,
 test: kill usage of fallocate in firmware-update.sh
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 23, 2018 at 12:58 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, Feb 22, 2018 at 10:59:22PM -0800, Dan Williams wrote:
>> The 'fallocate -l 196608 $image' step in the test fails when $image is
>> on an NFS mount. Use dd instead to create a sparse file. We do not need
>> to allocate anything since we are only writing zeros.
>>
>> Cc: Dave Jiang <dave.jiang@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  test/firmware-update.sh |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/test/firmware-update.sh b/test/firmware-update.sh
>> index 0d5bcdb3cc42..173647218c28 100755
>> --- a/test/firmware-update.sh
>> +++ b/test/firmware-update.sh
>> @@ -49,7 +49,7 @@ detect()
>>
>>  do_tests()
>>  {
>> -     fallocate -l 196608 $image
>> +     dd if=/dev/zero of=$image bs=1 count=1 skip=196607
>>       $ndctl update-firmware -d $dev -f $image
>>  }
>
> Hmm, I'm not seeing this failure in my NFS based setup.  Out of curiosity, do
> you know why it's failing?  Some difference in our NFS configs?

Probably, here are my mount options:

root on / type nfs4
(rw,relatime,vers=4.0,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.100.127,local_lock=none,addr=192.168.100.1)

> Anyway, this seems fine, but
>
> fallocate -l 196608 $image
>
> does the same thing and seems a little simpler, IMO.

Not simpler if it randomly fails depending on the filesystem, and
there is no need to allocate that space since we're just creating a
file full of zeros.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
