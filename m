Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x231.google.com (mail-ua0-x231.google.com
 [IPv6:2607:f8b0:400c:c08::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 116AD21D2DCEE
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 14:17:42 -0700 (PDT)
Received: by mail-ua0-x231.google.com with SMTP id w45so12634816uac.5
 for <linux-nvdimm@lists.01.org>; Tue, 01 Aug 2017 14:19:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1501621491.2475.20.camel@wdc.com>
References: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170801190257.GA10033@redhat.com>
 <CAPcyv4jxTQhHANEBmObwhvWW7JHnSmHfCqv3JL3xEm0YFamvrA@mail.gmail.com>
 <CAPcyv4hLP98cap0cgWWw_FOeh9yzLJVSaZURntsB0t2D24nF9Q@mail.gmail.com>
 <1501621491.2475.20.camel@wdc.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Aug 2017 14:19:50 -0700
Message-ID: <CAPcyv4gjN8AykVO2RoNorR0mOPOXVzg=8s3+mhueGF5+v0-mHA@mail.gmail.com>
Subject: Re: dm: enable opt-out of device-mapper dax support
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
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 1, 2017 at 2:04 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Tue, 2017-08-01 at 13:59 -0700, Dan Williams wrote:
>> On Tue, Aug 1, 2017 at 12:45 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Tue, Aug 1, 2017 at 12:02 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > > On Tue, Aug 01 2017 at  2:12pm -0400,
>> > > Dan Williams <dan.j.williams@intel.com> wrote:
>> > > > [ ... ]
>> > >
>> > > I'm questioning the need to have yet another Kbuild CONFIG option.  If
>> > > the user has enabled CONFIG_BLK_DEV_PMEM and CONFIG_FS_DAX (DAX already
>> > > gets selected by CONFIG_FS_DAX) then shouldn't the DM capabilities just
>> > > be enabled?
>> > >
>> > > Guess I'm just skeptical of: why do we want to move to a model where
>> > > users need to opt-in to DM support for DAX?
>> > >
>> > > I also _really_ don't like each target's DAX support being colocated in
>> > > drivers/md/dm-dax.c
>> > >
>> > > This all looks and feels like a serious step backwards.
>> >
>> > Ok, you want ifdef'd sections of DAX code in each target and make
>> > DM_DAX a silent option that gets enabled with BLK_DEV_PMEM, anything
>> > else?
>>
>> Actually, no, I was thrown off by Bart's suggestion to move code
>> around. I can handle this all by deleting "select DAX" and adding more
>> stubbed out dax helpers.
>
> Hello Mike and Dan,
>
> How about one *-dax.c file per *.c dm file that has to be modified to add DAX support?
> I think that approach would avoid collocation of code for different targets in a
> single dm-dax.c file and would also avoid that #ifdef CONFIG_DAX statements have to
> be added. This approach is orthogonal to removal of CONFIG_DM_DAX.

You're free to send an alternative approach, but the new ifdefs in
include/linux/dax.h seem to be the cleanest option to remove dax text
size when the device-mapper dax support is not needed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
