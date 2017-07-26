Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x235.google.com (mail-yw0-x235.google.com
 [IPv6:2607:f8b0:4002:c05::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E42D821D09181
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 09:05:58 -0700 (PDT)
Received: by mail-yw0-x235.google.com with SMTP id x125so90549190ywa.0
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 09:08:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170726142348.GA4130@linux.intel.com>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
 <20170726142348.GA4130@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 09:08:00 -0700
Message-ID: <CAPcyv4j4ifRiS-J42p1DfOU0TjMYAyc1_==72+RPXvutyXxpMA@mail.gmail.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Johannes Thumshirn <jthumshirn@suse.de>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 7:23 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Jul 26, 2017 at 06:23:08PM +0900, OGAWA Hirofumi wrote:
>> "Kani, Toshimitsu" <toshi.kani@hpe.com> writes:
>>
>> >  kernel BUG at fs/buffer.c:3305!
>> >  invalid opcode: 0000 [#1] SMP
>> >   :
>> >  Workqueue: writeback wb_workfn (flush-259:0)
>> >  task: ffff8d02595b8000 task.stack: ffffa22242400000
>> >  RIP: 0010:try_to_free_buffers+0xd2/0xe0
>> >  RSP: 0018:ffffa22242403830 EFLAGS: 00010246
>> >  RAX: 00afffc000001028 RBX: 0000000000000008 RCX: ffff8d012dcf19c0
>> >  RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffc468e3b52b80
>> >  RBP: ffffa22242403858 R08: 0000000000000000 R09: 000000000002067c
>> >  R10: ffff8d027ffe6000 R11: 0000000000000000 R12: 0000000000000000
>> >  R13: ffff8d022fccdbe0 R14: ffffc468e3b52b80 R15: ffffa22242403ad0
>> >  FS:  0000000000000000(0000) GS:ffff8d027fd40000(0000)
>>
>> The locking of this path seems to be broken. The guy familiar to
>> bdev_write_page() path will made real fix though, The following patch
>> should be explaining enough what is wrong.
>
> Is there someone in particular who is familiar with bdev_write_page() that is
> working on this fix, or does someone need to pick this up?

Another question, does ->rw_page() really buy us that much with the
pmem driver? If applications want to enjoy the lowest latency access
they can just use DAX. There's now only 4 drivers that use rw_page
since nvme dropped its usage and I'd be inclined to just rip it out.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
