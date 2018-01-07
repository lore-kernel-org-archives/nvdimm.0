Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x241.google.com (mail-io0-x241.google.com
 [IPv6:2607:f8b0:4001:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 54C9F222275B7
 for <linux-nvdimm@lists.01.org>; Sun,  7 Jan 2018 12:26:52 -0800 (PST)
Received: by mail-io0-x241.google.com with SMTP id x67so10899567ioi.9
 for <linux-nvdimm@lists.01.org>; Sun, 07 Jan 2018 12:32:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180104181202.GA14491@redhat.com>
References: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180104181202.GA14491@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 7 Jan 2018 12:31:59 -0800
Message-ID: <CAA9_cmd8ywgxwfy6ZDkc1ERfD56L4HbTo7NkS5T1N9m-ZcjgzA@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] dax, dm: stop requiring dax for device-mapper
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>, Paul Mackerras <paulus@samba.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 4, 2018 at 10:12 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Nov 29 2017 at  1:59pm -0500,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Changes since v5 [1]:
>> * Make DAX_DRIVER select DAX to simplify the Kconfig dependencies
>>   (Michael)
>> * Rebase on 4.15-rc1 and add new IS_ENABLED(CONFIG_DAX_DRIVER) checks in
>>   drivers/md/dm-log-writes.c.
>>
>> [1]: https://lists.01.org/pipermail/linux-nvdimm/2017-September/012569.html
>>
>> ---
>>
>> Hi Mike,
>>
>> Bart points out that the DAX core is unconditionally enabled if
>> device-mapper is enabled. Add some config machinery and some
>> stub/static-inline routines to allow dax infrastructure to be deleted
>> from device-mapper at compile time.
>
> Hey Dan,
>
> Did you want me to pick this up for 4.16 or were you thinking of sending
> the changes through a different tree?
>
> I'm fine with picking these up so long as you don't expect the dax.h and
> Kconfig changes to become a source of conflict come merge time.

There might be some more collisions as we are going to kill the DAX
support in axonram and dcssblk. If I get your reviewed-by on these
I'll take them through the nvdimm tree.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
