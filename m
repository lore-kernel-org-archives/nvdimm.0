Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075E1173F
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 16:57:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19A0421882;
	Fri, 11 Aug 2023 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1691773055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jh/MD/lVpbJqPL6b1CXFb+5Or2Aj2zKh54NAfHiCdsY=;
	b=IQKqxsZSi1JmiD+pw+Vxr9T1mJZRb605HdB91CZnnqt/Lje/RzphQ52vpgcpwGnwnd8KEh
	vqJBM7/vSh6g6A6GfawZNF87RbRv2Lubz/zKjV6lTKYDQ6SeX7LM4k2w4Bkao8CZsuuKI5
	iXW66VOBZHqjUY785IGzSBCnOl6rOUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1691773055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jh/MD/lVpbJqPL6b1CXFb+5Or2Aj2zKh54NAfHiCdsY=;
	b=WLvnoPvv6AHGxMRIYE38j5yzaSM1T368Y4MnxYOoiLa4W5Tj5xMi2crDduvNzoMv9E5kpG
	HdKSfNMEM64/06BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4DFD1138E2;
	Fri, 11 Aug 2023 16:57:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id WtE7BXxo1mS6VAAAMHmgww
	(envelope-from <colyli@suse.de>); Fri, 11 Aug 2023 16:57:32 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH v6 3/7] badblocks: improve badblocks_set() for multiple
 ranges handling
From: Coly Li <colyli@suse.de>
In-Reply-To: <CALTww2_oX2=bhV=W4BotC1EE-PhzWHwd5NwW6u1mB=sk4htnrw@mail.gmail.com>
Date: Sat, 12 Aug 2023 00:57:19 +0800
Cc: linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev,
 linux-raid <linux-raid@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Geliang Tang <geliang.tang@suse.com>,
 Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>,
 Vishal L Verma <vishal.l.verma@intel.com>,
 Wols Lists <antlists@youngman.org.uk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4D099AE9-6BA3-475A-B5DD-8C01CDD46214@suse.de>
References: <20220721121152.4180-1-colyli@suse.de>
 <20220721121152.4180-4-colyli@suse.de>
 <CALTww2_oX2=bhV=W4BotC1EE-PhzWHwd5NwW6u1mB=sk4htnrw@mail.gmail.com>
To: Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3731.600.7)



> 2022=E5=B9=B49=E6=9C=8821=E6=97=A5 20:13=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Jul 21, 2022 at 8:12 PM Coly Li <colyli@suse.de> wrote:

[snipped]

>>=20
>> + *        +--------------+
>> + * 4.2.2) If range E is acked and the setting range S is unacked, =
the setting
>> + *    request of S will be rejected, the result is also,
>> + *        +--------------+
>> + *        |       E      |
>> + *        +--------------+
>> + * 4.2.3) If range E is unacked, and the setting range S is acked, =
then S will
>> + *    inserted into middle of E and split previous range E into twp =
parts (E1
>=20
> s/twp/two/g

Will fix in next version.

>=20
>> + *    and E2), the result is,
>> + *        +----+----+----+
>> + *        | E1 |  S | E2 |
>> + *        +----+----+----+
>> + * 4.3) If the setting bad blocks range S is overlapped with an =
already set bad
>> + *    blocks range E. The range S starts after the start LBA of =
range E, and
>> + *    ends after the end LBA of range E, as the following chart =
shows,
>> + *            +-------------------+
>> + *            |          S        |
>> + *            +-------------------+
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + *    For this situation the range S can be divided into two parts, =
the first
>> + *    part (S1) ends at end range E, and the second part (S2) has =
rest range of
>> + *    origin S.
>> + *            +---------+---------+            +---------+      =
+---------+
>> + *            |    S1   |    S2   |            |    S1   |      |    =
S2   |
>> + *            +---------+---------+  =3D=3D=3D>      +---------+     =
 +---------+
>> + *        +-------------+                  +-------------+
>> + *        |      E      |                  |      E      |
>> + *        +-------------+                  +-------------+
>> + *     Now in this loop the setting range S1 and already set range E =
can be
>> + *     handled as the situations 4), the rest range S2 will be =
handled in next
>=20
> s/4/4.1/g

Nice catch, will fix it in next version.

>> + *     loop and ignored in this loop.
>>=20

[snipped]

>> + * 6) Special cases which above conditions cannot handle
>> + * 6.1) Multiple already set ranges may merge into less ones in a =
full bad table
>> + *        +-------------------------------------------------------+
>> + *        |                           S                           |
>> + *        +-------------------------------------------------------+
>> + *        |<----- BB_MAX_LEN ----->|
>> + *                                 +-----+     +-----+   +-----+
>> + *                                 | E1  |     | E2  |   | E3  |
>> + *                                 +-----+     +-----+   +-----+
>> + *     In the above example, when the bad blocks table is full, =
inserting the
>> + *     first part of setting range S will fail because no more =
available slot
>> + *     can be allocated from bad blocks table. In this situation a =
proper
>> + *     setting method should be go though all the setting bad blocks =
range and
>> + *     look for chance to merge already set ranges into less ones. =
When there
>> + *     is available slot from bad blocks table, re-try again to =
handle more
>> + *     setting bad blocks ranges as many as possible.
>> + *        +------------------------+
>> + *        |          S3            |
>> + *        +------------------------+
>> + *        |<----- BB_MAX_LEN ----->|
>> + *                                 +-----+-----+-----+---+-----+--+
>> + *                                 |       S1        |     S2     |
>> + *                                 +-----+-----+-----+---+-----+--+
>> + *     The above chart shows although the first part (S3) cannot be =
inserted due
>> + *     to no-space in bad blocks table, but the following E1, E2 and =
E3 ranges
>> + *     can be merged with rest part of S into less range S1 and S2. =
Now there is
>> + *     1 free slot in bad blocks table.
>> + *        +------------------------+-----+-----+-----+---+-----+--+
>> + *        |           S3           |       S1        |     S2     |
>> + *        +------------------------+-----+-----+-----+---+-----+--+
>> + *     Since the bad blocks table is not full anymore, re-try again =
for the
>> + *     origin setting range S. Now the setting range S3 can be =
inserted into the
>> + *     bad blocks table with previous freed slot from multiple =
ranges merge.
>> + * 6.2) Front merge after overwrite
>=20
> Is it better to use 'Front combine' here?

For the English language, maybe merge is proper in such context. But I =
am not native speaker, and not 100% sure.


>=20
>> + *    In the following example, in bad blocks table, E1 is an acked =
bad blocks
>> + *    range and E2 is an unacked bad blocks range, therefore they =
are not able
>> + *    to merge into a larger range. The setting bad blocks range S =
is acked,
>> + *    therefore part of E2 can be overwritten by S.
>> + *                      +--------+
>> + *                      |    S   |                             =
acknowledged
>> + *                      +--------+                         S:       =
1
>> + *              +-------+-------------+                   E1:       =
1
>> + *              |   E1  |    E2       |                   E2:       =
0
>> + *              +-------+-------------+
>> + *     With previous simplified routines, after overwriting part of =
E2 with S,
>> + *     the bad blocks table should be (E3 is remaining part of E2 =
which is not
>> + *     overwritten by S),
>> + *                                                             =
acknowledged
>> + *              +-------+--------+----+                    S:       =
1
>> + *              |   E1  |    S   | E3 |                   E1:       =
1
>> + *              +-------+--------+----+                   E3:       =
0
>> + *     The above result is correct but not perfect. Range E1 and S =
in the bad
>> + *     blocks table are all acked, merging them into a larger one =
range may
>> + *     occupy less bad blocks table space and make badblocks_check() =
faster.
>> + *     Therefore in such situation, after overwriting range S, the =
previous range
>> + *     E1 should be checked for possible front combination. Then the =
ideal
>> + *     result can be,
>> + *              +----------------+----+                        =
acknowledged
>> + *              |       E1       | E3 |                   E1:       =
1
>> + *              +----------------+----+                   E3:       =
0
>>=20

[snipped]

>> +/* Do exact work to set bad block range into the bad block table */
>> +static int _badblocks_set(struct badblocks *bb, sector_t s, int =
sectors,
>> +                         int acknowledged)
>> +{
>> +       int retried =3D 0, space_desired =3D 0;
>> +       int orig_len, len =3D 0, added =3D 0;
>> +       struct badblocks_context bad;
>> +       int prev =3D -1, hint =3D -1;
>> +       sector_t orig_start;
>> +       unsigned long flags;
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
>> +               /* round the start down, and the end up */
>> +               sector_t next =3D s + sectors;
>> +
>> +               rounddown(s, bb->shift);
>> +               roundup(next, bb->shift);
>> +               sectors =3D next - s;
>> +       }
>> +
>> +       write_seqlock_irqsave(&bb->lock, flags);
>> +
>> +       orig_start =3D s;
>> +       orig_len =3D sectors;
>> +       bad.ack =3D acknowledged;
>> +       p =3D bb->page;
>> +
>> +re_insert:
>> +       bad.start =3D s;
>> +       bad.len =3D sectors;
>> +       len =3D 0;
>> +
>> +       if (badblocks_empty(bb)) {
>> +               len =3D insert_at(bb, 0, &bad);
>> +               bb->count++;
>> +               added++;
>> +               goto update_sectors;
>> +       }
>> +
>> +       prev =3D prev_badblocks(bb, &bad, hint);
>> +
>> +       /* start before all badblocks */
>> +       if (prev < 0) {
>> +               if (!badblocks_full(bb)) {
>> +                       /* insert on the first */
>> +                       if (bad.len > (BB_OFFSET(p[0]) - bad.start))
>> +                               bad.len =3D BB_OFFSET(p[0]) - =
bad.start;
>> +                       len =3D insert_at(bb, 0, &bad);
>> +                       bb->count++;
>> +                       added++;
>> +                       hint =3D 0;
>> +                       goto update_sectors;
>=20
> I see it adds the check of 'prev>=3D0' after update_sectors. Is there =
a
> situation like this:
>=20
> The setting bad block is adjacent to prev[0]. It means the end of the
> setting bad block
> equals the offset of prev[0]. So it will miss the backward merge.

This situation is not handled, as the code comments after =
update_sectors: says,

>> +       /*
>> +        * Check whether the following already set range can be
>> +        * merged. (prev < 0) condition is not handled here,
>> +        * because it's already complicated enough.


If the backward merge is to be handled, we need to check the back block =
range, and extra split bad block range is possible.
It can be handled but a bit complicated for the special case, and I just =
feel it is not worthy.


>=20
>> +               }
>> +
>> +               /* No sapce, try to merge */
>> +               if (overlap_behind(bb, &bad, 0)) {
>> +                       if (can_merge_behind(bb, &bad, 0)) {
>> +                               len =3D behind_merge(bb, &bad, 0);
>> +                               added++;
>> +                       } else {
>> +                               len =3D BB_OFFSET(p[0]) - s;
>> +                               space_desired =3D 1;
>> +                       }
>> +                       hint =3D 0;
>> +                       goto update_sectors;
>> +               }
>> +
>> +               /* no table space and give up */
>> +               goto out;
>> +       }
>> +
>> +       /* in case p[prev-1] can be merged with p[prev] */
>> +       if (can_combine_front(bb, prev, &bad)) {
>> +               front_combine(bb, prev);
>> +               bb->count--;
>> +               added++;
>> +               hint =3D prev;
>> +               goto update_sectors;
>> +       }
>=20
> Does it need to do this job here? front_combine is used only after
> front_overwrite, right?

This is a special case, and good to have it here.
=46rom my testing it has to be placed here, other wise we will lose an =
opportunity for extra merge.


>=20
>> +
>> +       if (overlap_front(bb, prev, &bad)) {
>> +               if (can_merge_front(bb, prev, &bad)) {
>> +                       len =3D front_merge(bb, prev, &bad);
>> +                       added++;
>> +               } else {
>> +                       int extra =3D 0;
>> +
>> +                       if (!can_front_overwrite(bb, prev, &bad, =
&extra)) {
>> +                               len =3D min_t(sector_t,
>> +                                           BB_END(p[prev]) - s, =
sectors);
>> +                               hint =3D prev;
>> +                               goto update_sectors;
>> +                       }
>> +
>> +                       len =3D front_overwrite(bb, prev, &bad, =
extra);
>> +                       added++;
>> +                       bb->count +=3D extra;
>> +
>> +                       if (can_combine_front(bb, prev, &bad)) {
>> +                               front_combine(bb, prev);
>> +                               bb->count--;
>> +                       }
>> +               }
>> +               hint =3D prev;
>> +               goto update_sectors;
>> +       }
>> +
>> +       if (can_merge_front(bb, prev, &bad)) {
>> +               len =3D front_merge(bb, prev, &bad);
>> +               added++;
>> +               hint =3D prev;
>> +               goto update_sectors;
>> +       }
>> +
>> +       /* if no space in table, still try to merge in the covered =
range */
>> +       if (badblocks_full(bb)) {
>> +               /* skip the cannot-merge range */
>> +               if (((prev + 1) < bb->count) &&
>> +                   overlap_behind(bb, &bad, prev + 1) &&
>> +                   ((s + sectors) >=3D BB_END(p[prev + 1]))) {
>> +                       len =3D BB_END(p[prev + 1]) - s;
>> +                       hint =3D prev + 1;
>> +                       goto update_sectors;
>> +               }
>> +
>> +               /* no retry any more */
>> +               len =3D sectors;
>> +               space_desired =3D 1;
>> +               hint =3D -1;
>> +               goto update_sectors;
>> +       }
>> +
>> +       /* cannot merge and there is space in bad table */
>> +       if ((prev + 1) < bb->count &&
>> +           overlap_behind(bb, &bad, prev + 1))
>> +               bad.len =3D min_t(sector_t,
>> +                               bad.len, BB_OFFSET(p[prev + 1]) - =
bad.start);
>> +
>> +       len =3D insert_at(bb, prev + 1, &bad);
>> +       bb->count++;
>> +       added++;
>> +       hint =3D prev + 1;
>> +
>> +update_sectors:
>> +       s +=3D len;
>> +       sectors -=3D len;
>> +
>> +       if (sectors > 0)
>> +               goto re_insert;
>> +
>> +       WARN_ON(sectors < 0);
>> +
>> +       /*
>> +        * Check whether the following already set range can be
>> +        * merged. (prev < 0) condition is not handled here,
>> +        * because it's already complicatd enough.
>> +        */
>> +       if (prev >=3D 0 &&
>> +           (prev + 1) < bb->count &&
>> +           BB_END(p[prev]) =3D=3D BB_OFFSET(p[prev + 1]) &&
>> +           (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <=3D BB_MAX_LEN =
&&
>> +           BB_ACK(p[prev]) =3D=3D BB_ACK(p[prev + 1])) {
>> +               p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
>> +                                 BB_LEN(p[prev]) + BB_LEN(p[prev + =
1]),
>> +                                 BB_ACK(p[prev]));
>> +
>> +               if ((prev + 2) < bb->count)
>> +                       memmove(p + prev + 1, p + prev + 2,
>> +                               (bb->count -  (prev + 2)) * 8);
>   else
>          p[prev+1] =3D 0
>> +               bb->count--;

Clearing p[prev+1] is unnecessary. After bb->count=E2=80=94, p[prev+1] =
won=E2=80=99t be accessed anymore.=20


>> +       }
>> +
>> +       if (space_desired && !badblocks_full(bb)) {
>> +               s =3D orig_start;
>> +               sectors =3D orig_len;
>> +               space_desired =3D 0;
>> +               if (retried++ < 3)
>> +                       goto re_insert;
>> +       }
>> +
>> +out:
>> +       if (added) {
>> +               set_changed(bb);
>> +
>> +               if (!acknowledged)
>> +                       bb->unacked_exist =3D 1;
>> +               else
>> +                       badblocks_update_acked(bb);
>> +       }
>> +
>> +       write_sequnlock_irqrestore(&bb->lock, flags);
>> +
>> +       if (!added)
>> +               rv =3D 1;
>=20
> If some bad blocks are handled and put into the badblock table and =
some are not.
> Do we need to tell the caller about it? If added is not 0, it returns
> success to the caller.
> The caller thinks all sectors are handled. But in fact not.

Yes, you are right, this is a problem for current APIs since they were =
invented.
At this moment I don=E2=80=99t have plan to change the APIs, and just =
fix already know obvious bugs. So I choose to try best to keep existing =
behavior.

Thanks for your help on the code review :-)

Coly Li



