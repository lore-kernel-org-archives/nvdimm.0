Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x242.google.com (mail-yw0-x242.google.com
 [IPv6:2607:f8b0:4002:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1343F21CEB15C
 for <linux-nvdimm@lists.01.org>; Wed, 25 Oct 2017 05:15:38 -0700 (PDT)
Received: by mail-yw0-x242.google.com with SMTP id l32so17813991ywh.13
 for <linux-nvdimm@lists.01.org>; Wed, 25 Oct 2017 05:19:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjWp3khOix__jqfsiyjhNehGtkqXXv1o7EuGB1j3b2moQ@mail.gmail.com>
References: <20171020052943.15104-1-ross.zwisler@linux.intel.com>
 <20171020212556.30816-1-ross.zwisler@linux.intel.com>
 <CAOQ4uxjWp3khOix__jqfsiyjhNehGtkqXXv1o7EuGB1j3b2moQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 25 Oct 2017 15:19:22 +0300
Message-ID: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
Subject: Re: [fstests PATCH v2] generic: add test for DAX MAP_SYNC support
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
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 22, 2017 at 9:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Oct 21, 2017 at 12:25 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
>> Add a test that exercises DAX's new MAP_SYNC flag.
>>
>> This test creates a file and writes to it via an mmap(), but never syncs
>> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
>>
>> If MAP_SYNC is working the dm-log-writes replay will show the test file
>> with 1MiB of on-media block allocations.  This is because each allocating
>> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
>> (which you can test by fiddling with the parameters to mmap()) the file
>> will be smaller or missing entirely.
>>
>> Note that dm-log-writes doesn't track the data that we write via the
>> mmap(), so we can't do any data integrity checking.  We can only verify
>> that the metadata writes for the page faults happened.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> ---
>>
>> Changes since v1:
>>  - Addressed review feedback from Amir.  Thank you for the review!
>
> Looks good.
>
>>
>> ---
>>  .gitignore            |  1 +
>>  common/dmlogwrites    |  1 -
>>  src/Makefile          |  3 +-
>>  src/t_map_sync.c      | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/466     | 76 ++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/466.out |  3 ++
>>  tests/generic/group   |  1 +
>>  7 files changed, 175 insertions(+), 2 deletions(-)
>>  create mode 100644 src/t_map_sync.c
>>  create mode 100755 tests/generic/466
>>  create mode 100644 tests/generic/466.out
>>
>> diff --git a/.gitignore b/.gitignore
>> index 2014c08..9fc0695 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -119,6 +119,7 @@
>>  /src/t_getcwd
>>  /src/t_holes
>>  /src/t_immutable
>> +/src/t_map_sync
>>  /src/t_mmap_cow_race
>>  /src/t_mmap_dio
>>  /src/t_mmap_fallocate
>> diff --git a/common/dmlogwrites b/common/dmlogwrites
>> index 247c744..5b57df9 100644
>> --- a/common/dmlogwrites
>> +++ b/common/dmlogwrites
>> @@ -23,7 +23,6 @@ _require_log_writes()
>>         [ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
>>                 _notrun "This test requires a valid \$LOGWRITES_DEV"
>>
>> -       _exclude_scratch_mount_option dax

Wait. It this really ok to relax no dax from _require_log_writes()?
Shouldn't you check log-write target version or something to verify
that log-writes+dax is really supported?
I think you should.


>>         _require_dm_target log-writes
>>         _require_test_program "log-writes/replay-log"
>>  }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
