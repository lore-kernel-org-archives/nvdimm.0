Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x236.google.com (mail-io0-x236.google.com
 [IPv6:2607:f8b0:4001:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CA9B20958BD6
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 08:53:07 -0700 (PDT)
Received: by mail-io0-x236.google.com with SMTP id y123so29072127iod.0
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 08:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170911144111.GA15556@redhat.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150169668989.39569.8174620146135008137.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170911144111.GA15556@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Sep 2017 08:56:01 -0700
Message-ID: <CAPcyv4gBLPsogW_SUkBuAnZggP1WZqkNZZrxFZef7pmGFFFNkA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dm: allow device-mapper to operate without dax
 support
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
Cc: kbuild test robot <lkp@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 11, 2017 at 7:41 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Aug 02 2017 at  1:58pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Rather than have device-mapper directly 'select DAX', let the fact that
>> BLK_DEV_PMEM selects dax act as a gate for the device-mapper dax
>> support. We arrange for all the dax core routines to compile to nops
>> when CONFIG_DAX=n. With that in place we can simply handle the
>> alloc_dax() error as expected and ifdef out the other device-mapper-dax
>> support code.
>>
>> Now, if dax is provided by a leaf driver that driver may only arrange to
>> compile the dax core as a module. Since device-mapper dax support is
>> consumed by the always-built-in portion of the device-mapper
>> implementation we need to upgrade from DAX=m to DAX=y.
>
> I applied the patches and then got nervous once I dug in.. this last
> paragraph makes little sense to me.  "the always-built-in portion of the
> device-mapper implementation" is why: DM core can happily be compiled as
> a module (dm-mod.ko).
>
> And I'm not sure why you're referencing DAX related
> drivers/md/dm-builtin.c, why are you attachd DM's DAX support to that?
> I'm not seeing where that is actually happening.
>
> I don't see why DM's support for DAX would need to force DAX to be
> builtin rather than just a module.
>
> Sorry I didn't get around to looking at this until now, but it seems you
> went wrong along the way?  Or maybe I'm just missing something?
>

No, my fault, I didn't track BLK_DEV_DM_BUILTIN correctly and we can
safely make DAX a module when CONFIG_BLK_DEV_DM=m. I'll fix that up,
thanks for the catch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
