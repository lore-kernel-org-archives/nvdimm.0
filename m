Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E517E
	for <nvdimm@lists.linux.dev>; Mon,  6 Jun 2022 07:47:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D58041F390;
	Mon,  6 Jun 2022 07:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1654501624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a4ranTTnfhbeuCuNf2FBQcqlrOoydsUVzt8RgBn84aA=;
	b=S9wq/CCQeZNAtkTJozPMJ9O5IhbobRHFTROz3pTmNHz+dWM9YSbEeMCOZiDoj5JhwHjCOO
	jYDBC/OxBwGVdVdKiczJ9g33thIr3ahpG/moXbgX0qgr0eNafjLBy9ed/ksqnLTVnFSLnF
	/Bt4FV5paQ/3CXFuk5fGJuqjA3EbkS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1654501624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a4ranTTnfhbeuCuNf2FBQcqlrOoydsUVzt8RgBn84aA=;
	b=SBVlCvfkvzA1c9qKpgVylz3do0ylet89I8A9wpAyNno2RTB7hIGSv3akNZ1JFE79tUCYZb
	v/vZWbIhovRG9hCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B819139F5;
	Mon,  6 Jun 2022 07:47:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 44RWFvawnWI2WwAAMHmgww
	(envelope-from <colyli@suse.de>); Mon, 06 Jun 2022 07:47:02 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v5 2/6] badblocks: add helper routines for badblock ranges
 handling
From: Coly Li <colyli@suse.de>
In-Reply-To: <CALTww28HF2SPrrQAaLd+H_De5F8aOemBHfU03zMVAYatb7k19Q@mail.gmail.com>
Date: Mon, 6 Jun 2022 15:47:00 +0800
Cc: nvdimm@lists.linux.dev,
 linux-raid <linux-raid@vger.kernel.org>,
 linux-block@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>,
 Geliang Tang <geliang.tang@suse.com>,
 Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>,
 Vishal L Verma <vishal.l.verma@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B19DCF56-0FC1-4B87-A399-3A5FC8C4A416@suse.de>
References: <20211210160456.56816-1-colyli@suse.de>
 <20211210160456.56816-3-colyli@suse.de>
 <CALTww28HF2SPrrQAaLd+H_De5F8aOemBHfU03zMVAYatb7k19Q@mail.gmail.com>
To: Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3696.100.31)



> 2022=E5=B9=B41=E6=9C=882=E6=97=A5 15:04=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sat, Dec 11, 2021 at 12:05 AM Coly Li <colyli@suse.de> wrote:
>>=20
>>=20

[snipped]

>> block/badblocks.c | 376 =
++++++++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 376 insertions(+)
>>=20
>> diff --git a/block/badblocks.c b/block/badblocks.c
>> index d39056630d9c..30958cc4469f 100644
>> --- a/block/badblocks.c
>> +++ b/block/badblocks.c
>> @@ -16,6 +16,382 @@
>> #include <linux/types.h>
>> #include <linux/slab.h>
>>=20
>> +/*
>> + * Find the range starts at-or-before 's' from bad table. The search
>> + * starts from index 'hint' and stops at index 'hint_end' from the =
bad
>> + * table.
>> + */
>> +static int prev_by_hint(struct badblocks *bb, sector_t s, int hint)
>> +{
>> +       int hint_end =3D hint + 2;
>> +       u64 *p =3D bb->page;
>> +       int ret =3D -1;
>> +
>> +       while ((hint < hint_end) && ((hint + 1) <=3D bb->count) &&
>> +              (BB_OFFSET(p[hint]) <=3D s)) {
>> +               if ((hint + 1) =3D=3D bb->count || BB_OFFSET(p[hint + =
1]) > s) {
>> +                       ret =3D hint;
>> +                       break;
>> +               }
>> +               hint++;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +/*
>> + * Find the range starts at-or-before bad->start. If 'hint' is =
provided
>> + * (hint >=3D 0) then search in the bad table from hint firstly. It =
is
>> + * very probably the wanted bad range can be found from the hint =
index,
>> + * then the unnecessary while-loop iteration can be avoided.
>> + */
>> +static int prev_badblocks(struct badblocks *bb, struct =
badblocks_context *bad,
>> +                         int hint)
>> +{
>> +       sector_t s =3D bad->start;
>> +       int ret =3D -1;
>> +       int lo, hi;
>> +       u64 *p;
>> +
>> +       if (!bb->count)
>> +               goto out;
>> +
>> +       if (hint >=3D 0) {
>> +               ret =3D prev_by_hint(bb, s, hint);
>> +               if (ret >=3D 0)
>> +                       goto out;
>> +       }
>> +
>> +       lo =3D 0;
>> +       hi =3D bb->count;
>> +       p =3D bb->page;
>> +
>> +       while (hi - lo > 1) {
>> +               int mid =3D (lo + hi)/2;
>> +               sector_t a =3D BB_OFFSET(p[mid]);
>> +
>> +               if (a <=3D s)
>> +                       lo =3D mid;
>> +               else
>> +                       hi =3D mid;
>> +       }
>=20
> Hi Coly

Hi Xiao,

>=20
> Does it need to stop the loop when "a =3D=3D s". For example, there =
are
> 100 bad blocks.
> The new bad starts equals offset(50). In the first loop, it can find
> the result. It doesn't
> need to go on running in the loop. If it still runs the loop, only the
> hi can be handled.
> It has no meaning.

Yes, you are right. It can be improved with your suggestion, to avoid =
unnecessary extra loop.


>=20
>> +
>> +       if (BB_OFFSET(p[lo]) <=3D s)
>> +               ret =3D lo;
>> +out:
>> +       return ret;
>> +}
>> +
>> +/*
>> + * Return 'true' if the range indicated by 'bad' can be backward =
merged
>> + * with the bad range (from the bad table) index by 'behind'.
>> + */
>> +static bool can_merge_behind(struct badblocks *bb, struct =
badblocks_context *bad,
>> +                            int behind)
>> +{
>> +       sector_t sectors =3D bad->len;
>> +       sector_t s =3D bad->start;
>> +       u64 *p =3D bb->page;
>> +
>> +       if ((s <=3D BB_OFFSET(p[behind])) &&
>=20
> In fact, it can never trigger s =3D=3D BB_OFFSET here. By the design, =
if s
> =3D=3D offset(pos), prev_badblocks
> can find it. Then front_merge/front_overwrite can handle it.

Yes, s =3D=3D BB_OFFSET(p[behind]) should not happen in current =
situation. It is overthought, can be removed.

>=20
>> +           ((s + sectors) >=3D BB_OFFSET(p[behind])) &&
>> +           ((BB_END(p[behind]) - s) <=3D BB_MAX_LEN) &&
>> +           BB_ACK(p[behind]) =3D=3D bad->ack)
>> +               return true;
>> +       return false;
>> +}
>> +
>> +/*
>> + * Do backward merge for range indicated by 'bad' and the bad range
>> + * (from the bad table) indexed by 'behind'. The return value is =
merged
>> + * sectors from bad->len.
>> + */
>> +static int behind_merge(struct badblocks *bb, struct =
badblocks_context *bad,
>> +                       int behind)
>> +{
>> +       sector_t sectors =3D bad->len;
>> +       sector_t s =3D bad->start;
>> +       u64 *p =3D bb->page;
>> +       int merged =3D 0;
>> +
>> +       WARN_ON(s > BB_OFFSET(p[behind]));
>> +       WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
>> +
>> +       if (s < BB_OFFSET(p[behind])) {
>> +               WARN_ON((BB_LEN(p[behind]) + merged) >=3D =
BB_MAX_LEN);
>> +
>> +               merged =3D min_t(sector_t, sectors, =
BB_OFFSET(p[behind]) - s);
>=20
> sectors must be >=3D BB_OFFSET(p[behind] - s) here? It's behind_merge, =
so the end
> of bad should be >=3D BB_OFFSET(p[behind])


Yes, it=E2=80=99s overthought there, it can be simplified as,
	merged =3D BB_OFFSET(p[behind]) - s;


>=20
> If we need to check merged value. The WARN_ON should be checked after =
merged

Maybe you are right, but it is comfortable for me to check the length =
before doing the merge calculation. Anyway, almost all the WARN_ON() =
locations are overthought, most of them can be removed if not triggered =
during real workload for a while.

>=20
>> +               p[behind] =3D  BB_MAKE(s, BB_LEN(p[behind]) + merged, =
bad->ack);
>> +       } else {
>> +               merged =3D min_t(sector_t, sectors, =
BB_LEN(p[behind]));
>> +       }
>=20
> If we don't need to consider s =3D=3D offset(pos) situation, it only =
needs
> to consider s < offset(pos) here

Yes, the overthought part can be removed. I will re-write this part.


>> +
>> +       WARN_ON(merged =3D=3D 0);
>> +
>> +       return merged;
>> +}
>> +
>> +/*
>> + * Return 'true' if the range indicated by 'bad' can be forward
>> + * merged with the bad range (from the bad table) indexed by 'prev'.
>> + */
>> +static bool can_merge_front(struct badblocks *bb, int prev,
>> +                           struct badblocks_context *bad)
>> +{
>> +       sector_t s =3D bad->start;
>> +       u64 *p =3D bb->page;
>> +
>> +       if (BB_ACK(p[prev]) =3D=3D bad->ack &&
>> +           (s < BB_END(p[prev]) ||
>> +            (s =3D=3D BB_END(p[prev]) && (BB_LEN(p[prev]) < =
BB_MAX_LEN))))
>> +               return true;
>> +       return false;
>> +}
>> +
>> +/*
>> + * Do forward merge for range indicated by 'bad' and the bad range
>> + * (from bad table) indexed by 'prev'. The return value is sectors
>> + * merged from bad->len.
>> + */
>> +static int front_merge(struct badblocks *bb, int prev, struct =
badblocks_context *bad)
>> +{
>> +       sector_t sectors =3D bad->len;
>> +       sector_t s =3D bad->start;
>> +       u64 *p =3D bb->page;
>> +       int merged =3D 0;
>> +
>> +       WARN_ON(s > BB_END(p[prev]));
>> +
>> +       if (s < BB_END(p[prev])) {
>> +               merged =3D min_t(sector_t, sectors, BB_END(p[prev]) - =
s);
>> +       } else {
>> +               merged =3D min_t(sector_t, sectors, BB_MAX_LEN - =
BB_LEN(p[prev]));
>> +               if ((prev + 1) < bb->count &&
>> +                   merged > (BB_OFFSET(p[prev + 1]) - =
BB_END(p[prev]))) {
>> +                       merged =3D BB_OFFSET(p[prev + 1]) - =
BB_END(p[prev]);
>> +               }
>> +
>> +               p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
>> +                                 BB_LEN(p[prev]) + merged, =
bad->ack);
>> +       }
>> +
>> +       return merged;
>> +}
>> +
>> +/*
>> + * 'Combine' is a special case which can_merge_front() is not able =
to
>> + * handle: If a bad range (indexed by 'prev' from bad table) exactly
>> + * starts as bad->start, and the bad range ahead of 'prev' (indexed =
by
>> + * 'prev - 1' from bad table) exactly ends at where 'prev' starts, =
and
>> + * the sum of their lengths does not exceed BB_MAX_LEN limitation, =
then
>> + * these two bad range (from bad table) can be combined.
>> + *
>> + * Return 'true' if bad ranges indexed by 'prev' and 'prev - 1' from =
bad
>> + * table can be combined.
>> + */
>> +static bool can_combine_front(struct badblocks *bb, int prev,
>> +                             struct badblocks_context *bad)
>> +{
>> +       u64 *p =3D bb->page;
>> +
>> +       if ((prev > 0) &&
>> +           (BB_OFFSET(p[prev]) =3D=3D bad->start) &&
>> +           (BB_END(p[prev - 1]) =3D=3D BB_OFFSET(p[prev])) &&
>> +           (BB_LEN(p[prev - 1]) + BB_LEN(p[prev]) <=3D BB_MAX_LEN) =
&&
>> +           (BB_ACK(p[prev - 1]) =3D=3D BB_ACK(p[prev])))
>> +               return true;
>> +       return false;
>> +}
>=20
> could you explain why BB_OFFSET(p[prev]) should =3D=3D bad->start. If
> bad(prev-1) and

This is a special case, which the state-machine style loop in =
_badblocks_set() cannot handle.
Here is an example why can_combine_front() is necessary, the bad range =
is represent as (start offset, end offset), second number is not range =
len,
- existed bad ranges: [0, 16], [20, 500], [700, 800]
- inserting bad range: [10, 511]
- bad blocks table is full, no free slot can be allocated.

After the first loop in _badblocks_set(), the bad ranges and inserting =
bad range are,
- existed bad ranges: [0, 19], [20, 500], [700, 800]
- inserting range: [20, 511]

With can_combine_front() check, the first 2 existed bad ranges can be =
merged into 1, then the bad ranges can be,
- existed bad ranges: [0, 500], [700]   (a free slot is available after =
front_combine())
- inserting bad range: [20, 511]

Then next loop in _badblocks_set(), there is 1 free slot in bad blocks =
table, so the result is,
- existed bad ranges: [0, 511], [700, 800]
All inserting bad block range is handled and recored in bad blocks =
table.


If we don=E2=80=99t do the front_combine() with checking =
can_combine_front(), after the first loop in _badblocks_set(),
- existed bad ranges: [0, 19], [20, 511], [700, 800]
- inserting range: [20, 511]

Then after the last loop in _badblocks_set(), the result is,
- existed bad ranges: [0, 19], [20, 511], [700, 800]
The first 2 bad ranges have no chance to be combined into larger one.

> bad(prev) are adjacent, can they be combine directly without
> considering bad->start

So without combine_front(), in such situation these two bad ranges =
won=E2=80=99t be merged with current state-machine style code in =
_badblocks_set().

Thanks for your comments, I will update the patch to drop the =
overthought part.

Coly Li




