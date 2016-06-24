From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] dm: add infrastructure for DAX support
Date: Fri, 24 Jun 2016 11:44:47 -0400
Message-ID: <20160624154446.GB13898@redhat.com>
References: <1466715953-40692-1-git-send-email-snitzer@redhat.com>
 <1466715953-40692-4-git-send-email-snitzer@redhat.com>
 <1466724984.3504.380.camel@hpe.com>
 <20160624014930.GA10540@redhat.com>
 <1466782822.3504.391.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466782822.3504.391.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri, Jun 24 2016 at 11:40am -0400,
Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> On Thu, 2016-06-23 at 21:49 -0400, Mike Snitzer wrote:
> > On Thu, Jun 23 2016 at=A0=A07:36pm -0400,
> > Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> =A0:
> > > Thanks for the update. =A0I have a question about the above change. =
=A0Targets
> > > may have their own parameters. =A0For instance, dm-stripe has 'chunk_=
size',
> > > which is checked in stripe_ctr(). =A0DAX adds additional restriction =
that
> > > chunk_size needs to be aligned by page size. =A0So, I think we need t=
o keep
> > > target responsible to verify if DAX can be supported. =A0What do you =
think?
> >
> > We've never had to concern the dm-stripe target with hardware
> > specific chunk_size validation.=A0=A0The user is able to specify the
> > chunk_size via lvm2's lvcreate -I argument.=A0=A0Yes this gives users e=
nough
> > rope to hang themselves but it is very easy to configure a dm-stripe
> > device with the appropriate chunk size (PAGE_SIZE) from userspace.
> > =

> > But lvm2 could even be trained to make sure the chunk_size is a factor
> > of physical_block_size (PAGE_SIZE in the case of pmem) if the underlying
> > devices export queue/dax=3D1
> =

> lvcreate=A0-I only allows multiple of page size, so we are OK with lvm2. =
=A0I was
> wondering if the check in lvm2 is enough. =A0Are there any other tools th=
at may
> be used to configure stripe size? =A0Can we trust userspace on this?

Other than lvm2, I'm not aware of any other userspace tool that is
driving the dm-stripe target configuration.  So I think we can trust
userspace here until proven otherwise.  Good news is that any
misconfiguration will simply not work right?  Errors would result from
improperly sized IO right?
