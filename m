From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: dm stripe: add DAX support
Date: Wed, 20 Jul 2016 20:01:42 -0400
Message-ID: <20160721000142.GA21913@redhat.com>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
 <20160624182859.GD13898@redhat.com>
 <1468362104.8908.43.camel@hpe.com>
 <20160713020100.GA5872@redhat.com>
 <1468422189.8908.53.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468422189.8908.53.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: axboe-b10kYP2dOMg@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jul 13 2016 at 11:03am -0400,
Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> On Tue, 2016-07-12 at 22:01 -0400, Mike Snitzer wrote:
> > On Tue, Jul 12 2016 at=A0=A06:22pm -0400,
> > Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> > > On Fri, 2016-06-24 at 14:29 -0400, Mike Snitzer wrote:
> > > > =A0
> =A0:
> > Thanks for putting this summary together.=A0=A0Unfortunately none of th=
e DM
> > changes can be queued for 4.8 until Jens takes the 2 block core patches:
> > https://patchwork.kernel.org/patch/9196021/
> > https://patchwork.kernel.org/patch/9196019/
> > =

> > Not sure what the hold up and/or issue is with them.=A0=A0But I've asked
> > twice (and implicilty a 3rd time here).=A0=A0Hopefully they land in tim=
e for
> > 4.8.
> =

> Hi Jens,
> =

> Can you take the two patches above? =A0These patches add QUEUE_FLAG_DAX a=
nd its
> sysfs show func. =A0They allow device-mapper to set dax-capability based =
on its
> configuration, and also allow user applications to check dax-capability v=
ia
> sysfs.

Hi Jens,

As I shared with you before, here are the 2 patches I staged in
linux-next via linux-dm.git's 'for-next' (same as in the patchwork
references above) -- these were staged just so we had linux-next
coverage until you picked them up.

Please pick these up for 4.8 -- the changes are straightforward, are
required for DM's DAX support, and Dan Williams has also acked them:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/com=
mit/?h=3Dfor-next&id=3D6c00531c6affa42b165df73a1eac3289bc45f4c4
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/com=
mit/?h=3Dfor-next&id=3D51d1a5abcd0e88cb4528f35643245ea59cf234f1

Feel free to pick them up from patchwork or cherry-pick from
linux-dm.git

Thanks!
Mike
