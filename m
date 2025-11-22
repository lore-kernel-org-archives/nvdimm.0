Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3455A27FD7C
	for <nvdimm@lists.linux.dev>; Sat, 22 Nov 2025 06:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763793579; cv=none; b=odMsgH6NDH9kPnDyfLdi/Z6I6P7dJXNVybN7lIJu/lCGNb1p4NKdCpveEV1w1FAXaTZx85aJ6ETc6PxuWdO/XQeMUFen0UYO9yU7tHoeZ8UtS/yO2VbPvzHKiMAD4caegRgE/gMzn2mh4WwkGhU0h/+zrumB40hrm+TiQwyhHz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763793579; c=relaxed/simple;
	bh=am8ixBoMKhsSF/MdBH5QgyIc0JcOcDSbE9v7y8W7vhY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j3HtlnZR8yZBWrnq7I5sVOukokMrU5ifSDILDpGraqdeJFMCeglIGXg5L4HRfJCDwnhwi1Q5XDfRaaXv7UtmlHrZ25TwPE7M4vQXGWzSyWjJDphVMGIT24iEwhE9tWXes2LBkVTuSww8nl73ht9odLtEHng/oToTeeLkrLfAy5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kvfMROWw; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvfMROWw"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee1e18fb37so29055581cf.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 22:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763793576; x=1764398376; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YW35sxUxIlGDrd2+h8IaRlcKG4sa3HfSuqLbLrmJaJI=;
        b=kvfMROWwbgh5T8b43MfSF/peu0NMPRCyvsMMNrYzKRQZ4bDQbHPC9z6e/S4e8h0UjF
         Uh20gHoibIFNilhgpwVRYEk2CAAENs7mzdtk1PHojXORUlK54MfwuOE+D5qQoH3oOPhA
         jr11IUu9BdfDvGEthHpGTnpw0B0d7/rwOOegdu/PIynVaKQyNfoNUVy4eCrk9VoV2lQE
         dhjpImzTyxIu19b1z/FaevPV8aFNeRpBCNV+gDylp1Fyg6KgXOLBQhTu/pLTDq9uMeeI
         GIiFnkDNafBeXqdWDe93RakqBlGjI0DuC8QkiD39s/YWhIckyMBJhibfeefNTf7BbQMM
         tpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763793576; x=1764398376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YW35sxUxIlGDrd2+h8IaRlcKG4sa3HfSuqLbLrmJaJI=;
        b=jy3/DzNatU9wX+F4y8b0LCUXpsTXD2EGIILsbAqMhBjzg8kkW//AKXzp0T+SwI873q
         enDPWmNC31uloUKiU2qwaUuUS1WMKKw1Esy/qjFwwapdlHMg2clvgksCaVY30pXcsi9o
         BRU9MnXZ2jOxtANIp3u293y2nU/qXtfeXAV8p0kYRv29V8BEbOMfzWv8cVXuwawBg413
         sJRj3jfN1WVkbB7lKkWZuSGOzoY9KSJ7YZcJX7RWaAFcNVKUh6x/JGV3FG4AvTqQyHOL
         7uLjHIh5q6+jyYgYmN6VXbQOzKPJP6l0RQ7N+BiK1Og1I/aOJXmyTzhLk0txaXRgwE+d
         SGZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHdcTpN8VDTkDeN0Iv6dti21gzJQqXaLB7YODf1qzCK3JU4bAnuDvyMqrNrJ3boK8OCB/3+pQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywi/i42meMm5A/Mm0xuuBkfVzDsfZl+bv4fElFCjK21MUxV7PoQ
	J2ZuzsPq6Kht/6emixtGGNl2OfkRS8fRiJJNEB4HX8zeYuwYqcXNiEJWq1FNIl2YFPHa1M4FLpN
	DEHL+5LpqbKFSMLvUWcDQG0A51r9f1E8=
X-Gm-Gg: ASbGnctUXAmVYpJhe/imwW5SPNRG1iK8ej6YfuQw1jsLVMluiLj/pGf5NumHXc4g8il
	ys4hGl5x71GbQ7j+nWiTF2JpNs/ckk97R9xf0gwZR7DroXWNtD9QAusS+9DUO74JkASPZ1Ed5tV
	NsRUFFjsaLx9q4oQasehgstcHXb+j2WXS2UCajP2q1n5+VmuSrLt+ejk4sJqCRMaC/bJeRpCkMB
	wTd+piUYPl0Kq/D8hfq5RPsAyXt6PlTKRpVuL2v5YFfkAuH5ckL49JqW+aZbFFVqLgfV0w=
X-Google-Smtp-Source: AGHT+IF0DYx/ezSpM3sNXuPI7QGPPd1MKz4pLJ0a0/6OoiZEU9FOe4XHHmix0YrH/Vv9iTIapqMIoP7P9dG70k4KHUQ=
X-Received: by 2002:a05:622a:409:b0:4ee:84c:20c9 with SMTP id
 d75a77b69052e-4ee588cb648mr53122111cf.65.1763793575672; Fri, 21 Nov 2025
 22:39:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn> <aSBA4xc9WgxkVIUh@infradead.org>
In-Reply-To: <aSBA4xc9WgxkVIUh@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 14:38:59 +0800
X-Gm-Features: AWmQ_bmXTJbUJAhOvzCNFWsbGJVgzknSUgPoO-O5XzpCN3-HI1wRpjG5vYjbcM0
Message-ID: <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8821=
=E6=97=A5=E5=91=A8=E4=BA=94 18:37=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 21, 2025 at 04:17:39PM +0800, zhangshida wrote:
> > We have captured four instances of this corruption in our production
> > environment.
> > In each case, we observed a distinct pattern:
> >     The corruption starts at an offset that aligns with the beginning o=
f
> >     an XFS extent.
> >     The corruption ends at an offset that is aligned to the system's
> >     `PAGE_SIZE` (64KB in our case).
> >
> > Corruption Instances:
> > 1.  Start:`0x73be000`, **End:** `0x73c0000` (Length: 8KB)
> > 2.  Start:`0x10791a000`, **End:** `0x107920000` (Length: 24KB)
> > 3.  Start:`0x14535a000`, **End:** `0x145b70000` (Length: 8280KB)
> > 4.  Start:`0x370d000`, **End:** `0x3710000` (Length: 12KB)
>
> Do you have a somwhat isolate reproducer for this?
>
=3D=3D=3D=3D=3DThe background=3D=3D=3D=3D=3D
Sorry, We do not have a consistent way to reproduce this issue, as the
data was collected from a production environment run by database
providers. However, the I/O model is straightforward:

t0:A -> B
About 100 minutes later...
t1:A -> C

A, B, and C are three separate physical machines.

A is the primary writer. It runs a MySQL instance where a single thread
appends data to a log file.
B is a reader. At time t0, this server concurrently reads the log file from
A to perform a CRC check for backup purposes. The CRC check confirms
that the data on both A and B is identical and correct.
C is another reader. At time t1 (about 100 minutes after the A -> B backup
completed), this server also reads the log file from A for a CRC check.
However, this check on C indicates that the data is corrupt.

The most unusual part is that upon investigation, the data on the primary
server A was also found to be corrupt at this later time, differing from th=
e
correct state it was in at t0.

Another factor to consider is that memory reclamation is active, as the
environment uses cgroups to restrict resources, including memory.

After inspecting the corrupted data, we believe it did not originate from
any existing file. Instead, it appears to be raw data that was on the disk
before the intended I/O write was successfully completed.

This raises the question: how could a write I/O fail to make it to the disk=
?

A hardware problem seems unlikely, as different RAID cards and disks
are in use across the systems.
Most importantly, the corruption exhibits a distinct pattern:

It starts at an offset that aligns with the beginning of an XFS extent.
It ends at an offset that aligns with the system's PAGE_SIZE.

The starting address of an extent is an internal concept within the
filesystem, transparent to both user-space applications and lower-level
kernel modules. This makes it highly suspicious that the corruption
always begins at this specific boundary. This suggests a potential bug in
the XFS logic for handling append-writes to a file.

All we can do now is to do some desperate code analysis to see if we
can catch the bug.

=3D=3D=3D=3D=3D=3Dcode analysis=3D=3D=3D=3D=3D=3D
In kernel version 4.19, XFS handles extent I/O using the ioend structure,
which appears to represent a block of I/O to a continuous disk space.
This is broken down into multiple bio structures, as a single bio cannot
handle a very large I/O range:
| page 1| page 2 | ...| page N |
|<-------------ioend-------------->|
| bio 1      |  bio 2        | bio 3  |

To manage a large write, a chain of bio structures is used:
bio 1 -> bio 2 -> bio 3
All bios in this chain share a single end_io callback, which should only
be triggered after all I/O operations in the chain have completed.

The kernel uses the bi_remaining atomic counter on the first bio in the
chain to track completion, like:
1 -> 2 -> 2
if bio 1 completes, it will become:
1 -> 1 -> 2
if bio 2 completes:
1 -> 1 -> 1
if bio 3 completes:
1 -> 1 -> 0
So it is time to trigger the end io callback since all io is done.

But how does it handle a series of out-of-order completions?
if bio 3 completes first, it will become:
1 -> 2 -> 1
if bio 2 completes, since it seems forget to CHECK IF THE
FIRST BIO REACH 0 and go to next bio directly,
---c code----
static struct bio *__bio_chain_endio(struct bio *bio)
{
        struct bio *parent =3D bio->bi_private;

        if (bio->bi_status && !parent->bi_status)
                parent->bi_status =3D bio->bi_status;
        bio_put(bio);
        return parent;
}

static void bio_chain_endio(struct bio *bio)
{
        bio_endio(__bio_chain_endio(bio));
}
----c code----

it will become:
1 -> 2 -> 0
So it is time to trigger the end io callback since all io is done, which is
not actually the case. but bio 1 is still in an unknown state.



> > After analysis, we believe the root cause is in the handling of chained
> > bios, specifically related to out-of-order io completion.
> >
> > Consider a bio chain where `bi_remaining` is decremented as each bio in
> > the chain completes.
> > For example,
> > if a chain consists of three bios (bio1 -> bio2 -> bio3) with
> > bi_remaining count:
> > 1->2->2
> > if the bio completes in the reverse order, there will be a problem.
> > if bio 3 completes first, it will become:
> > 1->2->1
> > then bio 2 completes:
> > 1->1->0
> >
> > Because `bi_remaining` has reached zero, the final `end_io` callback
> > for the entire chain is triggered, even though not all bios in the
> > chain have actually finished processing. This premature completion can
> > lead to stale data being exposed, as seen in our case.
>
> It sounds like there is a problem because bi_remaining is only
> incremented after already submittin a bio.  Which code path do you
> see this with?  iomap doesn't chain bios, so is this the buffer cache
> or log code?  Or is there a remapping driver involved?
>

Yep. The commit below:

commit ae5535efd8c445ad6033ac0d5da0197897b148ea
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Dec 7 08:27:05 2023 +0100

    iomap: don't chain bios

changes the logic. Since there are still many code paths that use
bio_chain, I am including these cleanups with the fix. This provides a reas=
on
to CC all related communities. That way, developers who are monitoring
this can help identify similar problems if someone asks for help in the fut=
ure,
if that is the right analysis and fix.


Thanks,
Shida
