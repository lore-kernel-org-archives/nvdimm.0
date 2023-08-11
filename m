Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5F911CA4
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 16:57:43 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 203D421885;
	Fri, 11 Aug 2023 16:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1691773056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+RldD3Q47r+YYqib9ldiOtf7FKWGbNBt2vjIeJnkr34=;
	b=2SUM8ZhA7Nc2dv53dwQOj4ViwBV7xpK/Pw99C5SNclbZAQJ5X6vXee6x0BUvITAkz5P8xq
	CvGmmXWXYVq5nj3dfM8QsHkrVtXlaQy0Fgum9RojkTAgUeUjz//ZotuqyCtdSBYi3gaDvd
	01LryTVNyeBQBsWvCQpy3tmJsP5UHPU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1691773056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+RldD3Q47r+YYqib9ldiOtf7FKWGbNBt2vjIeJnkr34=;
	b=Q4lp1xym0HsLeXeadCTA2I55yNX5ubrSeun1dcxRFrKbQezd5Aierbxe12C1SYn0lnab4O
	FwkNuXMSknesu+Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 236B3138E3;
	Fri, 11 Aug 2023 16:57:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id kIizOH1o1mSwVAAAMHmgww
	(envelope-from <colyli@suse.de>); Fri, 11 Aug 2023 16:57:33 +0000
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH v6 4/7] badblocks: improve badblocks_clear() for multiple
 ranges handling
From: Coly Li <colyli@suse.de>
In-Reply-To: <CALTww2_-K4nf7wYsa6z4YsT=Ma-59iGkiKia6nZLAH4nreeMVQ@mail.gmail.com>
Date: Sat, 12 Aug 2023 00:57:23 +0800
Cc: linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev,
 linux-raid <linux-raid@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Geliang Tang <geliang.tang@suse.com>,
 Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>,
 Vishal L Verma <vishal.l.verma@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <30102E9A-984D-40F3-8BEC-738095814C0C@suse.de>
References: <20220721121152.4180-1-colyli@suse.de>
 <20220721121152.4180-5-colyli@suse.de>
 <CALTww2_-K4nf7wYsa6z4YsT=Ma-59iGkiKia6nZLAH4nreeMVQ@mail.gmail.com>
To: Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3731.600.7)

On Wed, Sep 21, 2022 at 11:26:52PM +0800, Xiao Ni wrote:
> On Thu, Jul 21, 2022 at 8:12 PM Coly Li <colyli@suse.de> wrote:
>>=20
[snipped]

>> + * setting does, but much more simpler. The only thing needs to be =
noticed is
>> + * when the clearing range hits middle of a bad block range, the =
existing bad
>> + * block range will split into two, and one more item should be =
added into the
>> + * bad block table. The simplified situations to be considered are, =
(The already
>> + * set bad blocks ranges in bad block table are naming with prefix =
E, and the
>> + * clearing bad blocks range is naming with prefix C)
>> + *
>> + * 1) A clearing range is not overlapped to any already set ranges =
in bad block
>> + *    table.
>> + *    +-----+         |          +-----+         |          +-----+
>> + *    |  C  |         |          |  C  |         |          |  C  |
>> + *    +-----+         or         +-----+         or         +-----+
>> + *            +---+   |   +----+         +----+  |  +---+
>> + *            | E |   |   | E1 |         | E2 |  |  | E |
>> + *            +---+   |   +----+         +----+  |  +---+
>> + *    For the above situations, no bad block to be cleared and no =
failure
>> + *    happens, simply returns 0.

[snipped]

>> + * 3.2) Exact fully covered
>> + *         +-----------------+
>> + *         |         C       |
>> + *         +-----------------+
>> + *         +-----------------+
>> + *         |         E       |
>> + *         +-----------------+
>> + *    For this situation the whole bad blocks range E will be =
cleared and its
>> + *    corresponded item is deleted from the bad block table.
>=20
> Does it need to add 3.3) here to explain when length of C is bigger =
than E
> Or we can change 3.2 to cover these two conditions. In the codes, it =
splits
> situation 3 into two parts.

When C is bigger than E, the extra range will go into condition 1) in =
next loop.
For the state machine style coding, every iteration only one piece is =
handled,
then the kind of complicated situations can be a bit simplified.

>> + * 4) The clearing range exactly ends at same LBA as an already set =
bad block
>> + *    range.
>> + *                   +-------+
>> + *                   |   C   |
>> + *                   +-------+
>> + *         +-----------------+
>> + *         |         E       |
>> + *         +-----------------+
>> + *    For the above situation, the already set range E is updated to =
shrink its
>> + *    end to the start of C, and reduce its length to BB_LEN(E) - =
BB_LEN(C).
>> + *    The result is,
>> + *         +---------+
>> + *         |    E    |
>> + *         +---------+
>> + * 5) The clearing range is partially overlapped with an already set =
bad block
>> + *    range from the bad block table.
>> + * 5.1) The already set bad block range is front overlapped with the =
clearing
>> + *    range.
>> + *         +----------+
>> + *         |     C    |
>> + *         +----------+
>> + *              +------------+
>> + *              |      E     |
>> + *              +------------+
>> + *   For such situation, the clearing range C can be treated as two =
parts. The
>> + *   first part ends at the start LBA of range E, and the second =
part starts at
>> + *   same LBA of range E.
>> + *         +----+-----+               +----+   +-----+
>> + *         | C1 | C2  |               | C1 |   | C2  |
>> + *         +----+-----+         =3D=3D=3D>  +----+   +-----+
>> + *              +------------+                 +------------+
>> + *              |      E     |                 |      E     |
>> + *              +------------+                 +------------+
>> + *   Now the first part C1 can be handled as condition 1), and the =
second part C2 can be
>> + *   handled as condition 3.1) in next loop.
>> + * 5.2) The already set bad block range is behind overlaopped with =
the clearing
>> + *   range.
>> + *                 +----------+
>> + *                 |     C    |
>> + *                 +----------+
>> + *         +------------+
>> + *         |      E     |
>> + *         +------------+
>> + *   For such situation, the clearing range C can be treated as two =
parts. The
>> + *   first part C1 ends at same end LBA of range E, and the second =
part starts
>> + *   at end LBA of range E.
>> + *                 +----+-----+                 +----+    +-----+
>> + *                 | C1 | C2  |                 | C1 |    | C2  |
>> + *                 +----+-----+  =3D=3D=3D>           +----+    =
+-----+
>> + *         +------------+               +------------+
>> + *         |      E     |               |      E     |
>> + *         +------------+               +------------+
>> + *   Now the first part clearing range C1 can be handled as =
condition 4), and
>> + *   the second part clearing range C2 can be handled as condition =
1) in next
>> + *   loop.
>> + *
>> + *   All bad blocks range clearing can be simplified into the above =
5 situations
>> + *   by only handling the head part of the clearing range in each =
run of the
>> + *   while-loop. The idea is similar to bad blocks range setting but =
much
>> + *   simpler.
>>  */
>=20
> The categorized situations are a little different with setting bad
> block. Is it better
> to use the same way as setting bad block? So we don't need to consider =
two
> categorized ways to avoid switching them when reading codes.
>=20

It is not easy to explain the bad block clearing logic exactly similar =
to bad
block setting logic. I'd like to have it in current shape which may =
follow the
sequence how code is implemented. If other people do have better idea to =
improve
this text block, I'd like to glad to review the change.


>>=20
>> /*
>> @@ -937,6 +1054,214 @@ static int _badblocks_set(struct badblocks =
*bb, sector_t s, int sectors,
>>        return rv;
>> }
>>=20
>> +/*
>> + * Clear the bad block range from bad block table which is front =
overlapped
>> + * with the clearing range. The return value is how many sectors =
from an
>> + * already set bad block range are cleared. If the whole bad block =
range is
>> + * covered by the clearing range and fully cleared, 'delete' is set =
as 1 for
>> + * the caller to reduce bb->count.
>> + */
>> +static int front_clear(struct badblocks *bb, int prev,
>> +                      struct badblocks_context *bad, int *deleted)
>> +{
>> +       sector_t sectors =3D bad->len;
>> +       sector_t s =3D bad->start;
>> +       u64 *p =3D bb->page;
>> +       int cleared =3D 0;
>> +
>> +       *deleted =3D 0;
>> +       if (s =3D=3D BB_OFFSET(p[prev])) {
>> +               if (BB_LEN(p[prev]) > sectors) {
>> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]) + =
sectors,
>> +                                         BB_LEN(p[prev]) - sectors,
>> +                                         BB_ACK(p[prev]));
>> +                       cleared =3D sectors;
>> +               } else {
>> +                       /* BB_LEN(p[prev]) <=3D sectors */
>> +                       cleared =3D BB_LEN(p[prev]);
>> +                       if ((prev + 1) < bb->count)
>> +                               memmove(p + prev, p + prev + 1,
>> +                                      (bb->count - prev - 1) * 8);
>                            else
>                                    p[prev] =3D 0

Clearing p[prev] is uncessary, the caller of front_clear() will decrease =
the
counter of the bad block table (bb->count), then p[prev] referenced here =
won't
be accessed anymore.

>> +                       *deleted =3D 1;
>> +               }
>> +       } else if (s > BB_OFFSET(p[prev])) {
>> +               if (BB_END(p[prev]) <=3D (s + sectors)) {
>> +                       cleared =3D BB_END(p[prev]) - s;
>> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
>> +                                         s - BB_OFFSET(p[prev]),
>> +                                         BB_ACK(p[prev]));
>> +               } else {
>> +                       /* Splitting is handled in =
front_splitting_clear() */
>> +                       BUG();
>> +               }
>> +       }
>> +
>> +       return cleared;
>> +}
>> +

[snipped]

>> +/* Do the exact work to clear bad block range from the bad block =
table */
>> +static int _badblocks_clear(struct badblocks *bb, sector_t s, int =
sectors)
>> +{
>> +       struct badblocks_context bad;
>> +       int prev =3D -1, hint =3D -1;
>> +       int len =3D 0, cleared =3D 0;
>> +       int rv =3D 0;
>> +       u64 *p;
>> +
>> +       if (bb->shift < 0)
>> +               /* badblocks are disabled */
>> +               return 1;
>> +
>> +       if (sectors =3D=3D 0)
>> +               /* Invalid sectors number */
>> +               return 1;
>> +
>> +       if (bb->shift) {
>> +               sector_t target;
>> +
>> +               /* When clearing we round the start up and the end =
down.
>> +                * This should not matter as the shift should align =
with
>> +                * the block size and no rounding should ever be =
needed.
>> +                * However it is better the think a block is bad when =
it
>> +                * isn't than to think a block is not bad when it is.
>> +                */
>> +               target =3D s + sectors;
>> +               roundup(s, bb->shift);
>> +               rounddown(target, bb->shift);
>> +               sectors =3D target - s;
>> +       }
>> +
>> +       write_seqlock_irq(&bb->lock);
>> +
>> +       bad.ack =3D true;
>> +       p =3D bb->page;
>> +
>> +re_clear:
>> +       bad.start =3D s;
>> +       bad.len =3D sectors;
>> +
>> +       if (badblocks_empty(bb)) {
>> +               len =3D sectors;
>> +               cleared++;
>> +               goto update_sectors;
>> +       }
>> +
>> +
>> +       prev =3D prev_badblocks(bb, &bad, hint);
>> +
>> +       /* Start before all badblocks */
>> +       if (prev < 0) {
>> +               if (overlap_behind(bb, &bad, 0)) {
>> +                       len =3D BB_OFFSET(p[0]) - s;
>> +                       hint =3D prev;
>=20
> s/prev/0/g

Yeah, setting hint to 0 can avoid potential unnecessary extra loop in =
prev_badblocks().
I will use it in next version, nice catch!


>> +               } else {
>> +                       len =3D sectors;
>> +               }
>> +               /*
>> +                * Both situations are to clear non-bad range,
>> +                * should be treated as successful
>> +                */
>> +               cleared++;
>> +               goto update_sectors;
>> +       }
>> +
>> +       /* Start after all badblocks */
>> +       if ((prev + 1) >=3D bb->count && !overlap_front(bb, prev, =
&bad)) {
>=20
> If we only want to check if it starts after all badblocks, we can use
> bad->start >=3D BB_END(p[prev]) directly. It's more easy to understand
> than !overlap_front.

But how to know p[prev] is the last record in the bad block table?

>=20
>> +               len =3D sectors;
>> +               cleared++;
>> +               goto update_sectors;
>> +       }
>> +
>> +       /* Clear will split a bad record but the table is full */
>> +       if (badblocks_full(bb) && (BB_OFFSET(p[prev]) < bad.start) &&
>> +           (BB_END(p[prev]) > (bad.start + sectors))) {
>> +               len =3D sectors;
>> +               goto update_sectors;
>> +       }
>=20
> Can we move this check to overlap_front situation
>=20
>> +
>> +       if (overlap_front(bb, prev, &bad)) {
>> +               if ((BB_OFFSET(p[prev]) < bad.start) &&
>> +                   (BB_END(p[prev]) > (bad.start + bad.len))) {
>> +                       /* Splitting */
>=20
> If we move the check of table here, it should be
>                    if (bb->count + 1 >=3D MAX_BADBLOCKS) {
>                           len =3D sectors;
>                           goto update_sectors;
>                   }
> Then it can do front_splitting_clear directly.
>=20

Yes, it could be. But there will be a 'goto update_sectors' inside a =
quite deep
if-else code block, and later there is another goto inside this if-else =
code
block. I don't like this, this is why you see the code in current =
shapte. Only
one 'goto update_sectors' in the first level of if-else makes me much =
comfortable.

>> +                       if ((bb->count + 1) < MAX_BADBLOCKS) {
>> +                               len =3D front_splitting_clear(bb, =
prev, &bad);
>> +                               bb->count +=3D 1;
>> +                               cleared++;
>> +                       } else {
>> +                               /* No space to split, give up */
>> +                               len =3D sectors;
>> +                       }
>> +               } else {
>> +                       int deleted =3D 0;
>> +
>> +                       len =3D front_clear(bb, prev, &bad, =
&deleted);
>> +                       bb->count -=3D deleted;
>> +                       cleared++;
>> +                       hint =3D prev;
>> +               }
>> +
>> +               goto update_sectors;

Only one 'goto update_sectors' at the above line is much better IMHO, as
I mentioned in previous reply.

>> +       }
>> +
>> +       /* Not front overlap, but behind overlap */
>> +       if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + =
1)) {
>> +               len =3D BB_OFFSET(p[prev + 1]) - bad.start;
>> +               hint =3D prev + 1;
>> +               /* Clear non-bad range should be treated as =
successful */
>> +               cleared++;
>> +               goto update_sectors;
>> +       }
>=20
> Can we do this like setting bad blocks? It can check behind overlap
> after the loop?
> So it can use the loop to handle the clearing bad block until the end =
of it.

'len' has to be updated before go to update_sectors, I am not able to =
move
the above code block to the location after 'update_sectors:'. Not sure =
whether
I answer your question...

Thank you for the help on code review!

Coly Li=20
