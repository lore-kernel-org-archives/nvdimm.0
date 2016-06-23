Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 23 Jun 2016 17:11:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/3] block: add QUEUE_FLAG_DAX for devices to
 advertise their DAX support
Message-ID: <20160623211131.GA9163@redhat.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
 <1466639694-25394-2-git-send-email-toshi.kani@hpe.com>
 <CACTTzNYAxtY-d8+8Vo=Y2WpuXVaSkJk9PC7DcHXKJuU=gqvXFw@mail.gmail.com>
 <1466702773.3504.363.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466702773.3504.363.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 23 2016 at  1:36pm -0400,
Kani, Toshimitsu <toshi.kani@hpe.com> wrote:

> On Thu, 2016-06-23 at 19:31 +0300, Yigal Korman wrote:
> > On Thu, Jun 23, 2016 at 2:54 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > > =

> > > =

> > > Currently, presence of direct_access() in block_device_operations
> > > indicates support of DAX on its block device.=A0=A0Because
> > > block_device_operations is instantiated with 'const', this DAX
> > > capablity may not be enabled conditinally.
> > > =

> > > In preparation for supporting DAX to device-mapper devices, add
> > > QUEUE_FLAG_DAX to request_queue flags to advertise their DAX
> > > support.=A0=A0This will allow to set the DAX capability based on how
> > > mapped device is composed.
> > =

> > Hi Toshi,
> > This patch is very helpful!
> > I think QUEUE_FLAG_DAX can also help with identifying dax devices in
> > userspace.
> > Perhaps you'd be willing to squash the patch below with this one or
> > add it to your submission?
> =

> Hi Yigal,
> =

> Good idea. =A0Mike can probably take it into his tree, but I will include=
 it
> into the series if I needed to submit v3.
> =

> Acked-by: Toshi Kani <toshi.kani@hpe.com>

As you can see I sent out v3 of this set.  Jens will need to pick up the
"block:" patches but I'll pick up the DM patches once Jens does so.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
