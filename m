Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F6CB21E8797A
 for <linux-nvdimm@lists.01.org>; Sat,  9 Sep 2017 11:53:51 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id x190so29303027oix.3
 for <linux-nvdimm@lists.01.org>; Sat, 09 Sep 2017 11:56:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170802185537.GA16551@redhat.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170802185537.GA16551@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 9 Sep 2017 11:56:43 -0700
Message-ID: <CAPcyv4iTkv_5yR2aLz+wwE=XkwmwOtWUB3_4O3jcVjkf27XYwQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] dax, dm: stop requiring dax for device-mapper
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
Cc: kbuild test robot <lkp@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 2, 2017 at 11:55 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Aug 02 2017 at  1:57pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Changes since v2 [1]:
>> * rebase on -next to integrate with commit 273752c9ff03 "dm, dax: Make
>>   sure dm_dax_flush() is called if device supports it" (kbuild robot)
>> * fix CONFIG_DAX dependencies to upgrade CONFIG_DAX=m to CONFIG_DAX=y
>>   (kbuild robot)
>>
>> [1]: https://www.spinics.net/lists/kernel/msg2570522.html
>>
>> ---
>>
>> Bart points out that the DAX core is unconditionally enabled if
>> device-mapper is enabled. Add some config machinery and some
>> stub-static-inline routines to allow dax infrastructure to be deleted
>> from device-mapper at compile time.
>>
>> Since this depends on commit 273752c9ff03 that's already in -next, this
>> should go through the device-mapper tree.
>
> Commit 273752c9ff03eb83856601b2a3458218bb949e46 is upstream as of
> v4.13-rc3 -- so no real need to have this go via linux-dm.git
>
> That said, I don't mind picking it up once we are satisfied with the
> implementation.  I'll start reviewing shortly.

Hi Mike,

Friendly reminder about this cleanup...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
