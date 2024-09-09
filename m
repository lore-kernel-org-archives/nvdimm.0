Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5088218E740
	for <nvdimm@lists.linux.dev>; Mon,  9 Sep 2024 23:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925989; cv=none; b=WH1SuhJA9MHJbDDJxTK5eyVqAgvFjI39JienWCjLQh8g2xD+PyU2Mc4lSJ3fKfeQ6yvHjRGZPO4QYQFHO9PCVllVeAulwpJAmX2tE/6LMMN13GU5ebVbazXCE/UBQDiP12ZiSEhfNp3FyQRBTa2TZRLljMNq7+Gsykc23pHgv+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925989; c=relaxed/simple;
	bh=93DJqojuKjkTdhcHgvdkzwZLsPNskOSznfMdg8BeRjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGRA8AHpNZ2cN5ZI2g57y+grsid4aZ5E3/sfDAFdFks1btg8WFX9H29ZtGqOUPH8ZbvFSTrqsWvxo3UVI6ORCvsQ1jm1j6rd5T0YOjQkMRUsh7zzDKdd9a3dLJLErmKNHaFejF68xgy33bBTx179aVwitbfuI1q1IuQf8qDpNAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bWxclG8/; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bWxclG8/"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a9aec89347so121078885a.0
        for <nvdimm@lists.linux.dev>; Mon, 09 Sep 2024 16:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725925986; x=1726530786; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5txSkUam2KVmJ0zi846w3pJlJlmv+1vLotb8f8z6fXo=;
        b=bWxclG8/gWAolrEf4Y61knmtyQK2Dj9xq8PFY+ZpOg4fjH8dRtRLdy723xjmIGE49R
         kcdU1iK+OEEqn8wtwCsAOqaK3Ln/7PpFHD4SLMZE3DNuhesDwJi59nt9rI+te78KsPuC
         5F0AoIGetql8ThkYOh1JSYw6DVyottsqwQTJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725925986; x=1726530786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5txSkUam2KVmJ0zi846w3pJlJlmv+1vLotb8f8z6fXo=;
        b=MNv45LVZ5FJP6l4wx16FV2s9pOGghk+mW23KMfAdIr8O3rBWOtk7+hhQRriU1NK+DO
         uWlqguist52Evgm0JA4QBc2tRMIyaTh4Usn7uPYFzCOkfmXwi1jgP0hA5e9S7x7Udx1p
         amPpmDRowtZDjp0H2G+HRhM5iIfZLXJrMGvYh6D9bdnFAcJsnqdMI2a/GPHEvN66R5tr
         /uKooyPmXJ08gKMTVSUOVDb0TIXZQyjsVcOA9wbaHHbOAXETGSzMbtVqJMHW4gkp+gcE
         6NXm53K2p0W3kHYFz+biTEKWHiZaxgJXWzmxtucPzkyRg8lKyZSzuU+Uia/zkvD1Rtin
         IclA==
X-Forwarded-Encrypted: i=1; AJvYcCWK+Tl/XGmuU7zmQP0MwqdVVOude+7/lMLIlFlSryDT9WSia+3REzIurEzbGHfcygZp97jqBXs=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywf2G6naWavS/8NnaZ6zwwyhZX5oDTPpaxSgEZAflcCDxjx55d5
	DbWreRNF3ozI4VD76O6fTqTeYbVtfRJEMG49UYERzL69LEs3pGNhH0cbdXiwG6BxPNY32XeEALs
	cHY1pyuKv8RTYUsfPI/K25KOR+TV66EnFxCK4
X-Google-Smtp-Source: AGHT+IHcZmhN6BQ2Z0+LRnxFANlmFVMKp4G/+B7owpMej9pK2QQtphdtxnpR5MG6qG2uIg8xuzf6ob271P04Zgf+Eqw=
X-Received: by 2002:a05:620a:258c:b0:7a1:c40c:fc66 with SMTP id
 af79cd13be357-7a99738e2d9mr1772866685a.56.1725925985991; Mon, 09 Sep 2024
 16:53:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815004617.2325269-1-philipchen@chromium.org>
 <CA+cxXhneUKWr+VGOjmOtWERA53WGcubjWBuFbVBBuJhNhSoBcQ@mail.gmail.com> <66d89eaeb0a4b_1e9158294e1@iweiny-mobl.notmuch>
In-Reply-To: <66d89eaeb0a4b_1e9158294e1@iweiny-mobl.notmuch>
From: Philip Chen <philipchen@chromium.org>
Date: Mon, 9 Sep 2024 16:52:55 -0700
Message-ID: <CA+cxXhmexXuXJg2qgbDJO7MXqpJzuDH1_Hru=7Ei9jus=FGwew@mail.gmail.com>
Subject: Re: [PATCH] virtio_pmem: Add freeze/restore callbacks
To: Ira Weiny <ira.weiny@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Wed, Sep 4, 2024 at 10:54=E2=80=AFAM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Philip Chen wrote:
> > Hi maintainers,
> >
> > Can anyone let me know if this patch makes sense?
> > Any comment/feedback is appreciated.
> > Thanks in advance!
>
> I'm not an expert on virtio but the code looks ok on the surface.  I've
> discussed this with Dan a bit and virtio-pmem is not heavily tested.

Thanks for your comments.
I think this specific patch is not heavily involved with virtio spec detail=
s.
This patch simply provides the basic freeze/restore PM callbacks for
virtio_pmem, like people already did for the other virtio drivers.

>
> Based on our discussion [1] I wonder if there is a way we can recreate th=
is
> with QEMU to incorporate into our testing?

Yes, these are how I test on crosvm, but I believe the same steps can
be applied to QEMU:
(1) Set pm_test_level to TEST_PLATFORM (build time change)
(2) Write something to pmem
(3) Make the device go through a freeze/restore cycle by writing
`disk` to `/sys/power/state`
(4) Validate the data written to pmem in (2) is still preserved

Note:
(a) The freeze/restore PM routines are sometimes called as the backup
for suspend/resume PM routines in a suspend/resume cycle.
In this case, we can also test freeze/restore PM routines with
suspend/resume: i.e. skip (1) and write `mem` to `sys/power/state` in
(3).
(b) I also tried to set up QEMU for testing. But QEMU crashes when I
try to freeze the device even without applying this patch.
Since the issue seems to be irrelevant to pmem and most likely a QEMU
setup problem on my end, I didn't spend more time enabling QEMU.



>
> Ira
>
> [1] https://lore.kernel.org/lkml/CA+cxXhnb2i5O7_BiOfKLth5Zwp5T62d6F6c39vn=
uT53cUkU_uw@mail.gmail.com/
>
> >
> > On Wed, Aug 14, 2024 at 5:46=E2=80=AFPM Philip Chen <philipchen@chromiu=
m.org> wrote:
> > >
> > > Add basic freeze/restore PM callbacks to support hibernation (S4):
> > > - On freeze, delete vq and quiesce the device to prepare for
> > >   snapshotting.
> > > - On restore, re-init vq and mark DRIVER_OK.
> > >
> > > Signed-off-by: Philip Chen <philipchen@chromium.org>
> > > ---
> > >  drivers/nvdimm/virtio_pmem.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > >
> > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pme=
m.c
> > > index c9b97aeabf85..2396d19ce549 100644
> > > --- a/drivers/nvdimm/virtio_pmem.c
> > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > @@ -143,6 +143,28 @@ static void virtio_pmem_remove(struct virtio_dev=
ice *vdev)
> > >         virtio_reset_device(vdev);
> > >  }
> > >
> > > +static int virtio_pmem_freeze(struct virtio_device *vdev)
> > > +{
> > > +       vdev->config->del_vqs(vdev);
> > > +       virtio_reset_device(vdev);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int virtio_pmem_restore(struct virtio_device *vdev)
> > > +{
> > > +       int ret;
> > > +
> > > +       ret =3D init_vq(vdev->priv);
> > > +       if (ret) {
> > > +               dev_err(&vdev->dev, "failed to initialize virtio pmem=
's vq\n");
> > > +               return ret;
> > > +       }
> > > +       virtio_device_ready(vdev);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  static unsigned int features[] =3D {
> > >         VIRTIO_PMEM_F_SHMEM_REGION,
> > >  };
> > > @@ -155,6 +177,8 @@ static struct virtio_driver virtio_pmem_driver =
=3D {
> > >         .validate               =3D virtio_pmem_validate,
> > >         .probe                  =3D virtio_pmem_probe,
> > >         .remove                 =3D virtio_pmem_remove,
> > > +       .freeze                 =3D virtio_pmem_freeze,
> > > +       .restore                =3D virtio_pmem_restore,
> > >  };
> > >
> > >  module_virtio_driver(virtio_pmem_driver);
> > > --
> > > 2.46.0.76.ge559c4bf1a-goog
> > >
>
>
