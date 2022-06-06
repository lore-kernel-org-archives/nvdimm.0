Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E197E
	for <nvdimm@lists.linux.dev>; Mon,  6 Jun 2022 07:52:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6FB221A50;
	Mon,  6 Jun 2022 07:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1654501627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VSytMia8FloG7q5g0djPAjaJLscLG51Gjbt/itMhJRM=;
	b=npT+m6Nvr9DBja4ZP5Es54yjcI+RPsrzqvcIB8njpCcXjAQpFTYSQ9cI2THbs+qRgzzGer
	5GWbnYiMWlB4njGrX1TSWj7iJ32ZftY0UqBjLewOEUVRTOGO8IWCqlSVS+MxY6/p3Wcvrn
	5L2jHHZpH48yslJq+1vt+X59CeKujnY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1654501627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VSytMia8FloG7q5g0djPAjaJLscLG51Gjbt/itMhJRM=;
	b=gjWOMhK1AWsbLnvPsfq2dCfOs4xgAF90JlNENmdhu5ayMDawiN2imHbayFGOeXEBvHmyHe
	GJr7lADNH51acOCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40AF1139F5;
	Mon,  6 Jun 2022 07:47:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id MEfABPmwnWI2WwAAMHmgww
	(envelope-from <colyli@suse.de>); Mon, 06 Jun 2022 07:47:05 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v5 3/6] badblocks: improve badblocks_set() for multiple
 ranges handling
From: Coly Li <colyli@suse.de>
In-Reply-To: <CALTww28rMvTqje_H5=055kSG4k+g5CvEjOWihDjhSRGbhCcixA@mail.gmail.com>
Date: Mon, 6 Jun 2022 15:47:02 +0800
Cc: nvdimm@lists.linux.dev,
 linux-raid <linux-raid@vger.kernel.org>,
 linux-block@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>,
 Geliang Tang <geliang.tang@suse.com>,
 Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>,
 Vishal L Verma <vishal.l.verma@intel.com>,
 Wols Lists <antlists@youngman.org.uk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BBE6CBD9-C0CE-4CC0-A2D1-03C50EA5545F@suse.de>
References: <20211210160456.56816-1-colyli@suse.de>
 <20211210160456.56816-4-colyli@suse.de>
 <CALTww28rMvTqje_H5=055kSG4k+g5CvEjOWihDjhSRGbhCcixA@mail.gmail.com>
To: Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3696.100.31)



> 2022=E5=B9=B41=E6=9C=882=E6=97=A5 21:48=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sat, Dec 11, 2021 at 12:05 AM Coly Li <colyli@suse.de> wrote:
>>=20
>> Recently I received a bug report that current badblocks code does not
>> properly handle multiple ranges. For example,
>>        badblocks_set(bb, 32, 1, true);
>>        badblocks_set(bb, 34, 1, true);
>>        badblocks_set(bb, 36, 1, true);
>>        badblocks_set(bb, 32, 12, true);
>> Then indeed badblocks_show() reports,
>>        32 3
>>        36 1
>> But the expected bad blocks table should be,
>>        32 12
>> Obviously only the first 2 ranges are merged and badblocks_set() =
returns
>> and ignores the rest setting range.
>>=20
>> This behavior is improper, if the caller of badblocks_set() wants to =
set
>> a range of blocks into bad blocks table, all of the blocks in the =
range
>> should be handled even the previous part encountering failure.
>>=20
>> The desired way to set bad blocks range by badblocks_set() is,
>> - Set as many as blocks in the setting range into bad blocks table.
>> - Merge the bad blocks ranges and occupy as less as slots in the bad
>>  blocks table.
>> - Fast.
>>=20
>> Indeed the above proposal is complicated, especially with the =
following
>> restrictions,
>> - The setting bad blocks range can be acknowledged or not =
acknowledged.
>> - The bad blocks table size is limited.
>> - Memory allocation should be avoided.
>>=20
>> The basic idea of the patch is to categorize all possible bad blocks
>> range setting combinations into to much less simplified and more less
> typo error? s/to//g

It will be fixed in next version. Thanks.


>=20
>> special conditions. Inside badblocks_set() there is an implicit loop
>> composed by jumping between labels 're_insert' and 'update_sectors'. =
No
>> matter how large the setting bad blocks range is, in every loop just =
a
>> minimized range from the head is handled by a pre-defined behavior =
from
>> one of the categorized conditions. The logic is simple and code flow =
is
>> manageable.
>>=20
>> The different relative layout between the setting range and existing =
bad
>> block range are checked and handled (merge, combine, overwrite, =
insert)
>> by the helpers in previous patch. This patch is to make all the =
helpers
>> work together with the above idea.
>>=20
>> This patch only has the algorithm improvement for badblocks_set(). =
There
>> are following patches contain improvement for badblocks_clear() and
>> badblocks_check(). But the algorithm in badblocks_set() is =
fundamental
>> and typical, other improvement in clear and check routines are based =
on
>> all the helpers and ideas in this patch.
>>=20
>> In order to make the change to be more clear for code review, this =
patch
>> does not directly modify existing badblocks_set(), and just add a new
>> one named _badblocks_set(). Later patch will remove current existing
>> badblocks_set() code and make it as a wrapper of _badblocks_set(). So
>> the new added change won't be mixed with deleted code, the code =
review
>> can be easier.
>>=20
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Geliang Tang <geliang.tang@suse.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Vishal L Verma <vishal.l.verma@intel.com>
>> Cc: Wols Lists <antlists@youngman.org.uk>
>> ---
>> block/badblocks.c | 560 =
++++++++++++++++++++++++++++++++++++++++++++--
>> 1 file changed, 540 insertions(+), 20 deletions(-)
>>=20
>> diff --git a/block/badblocks.c b/block/badblocks.c
>> index 30958cc4469f..f45f82646bb7 100644
>> --- a/block/badblocks.c
>> +++ b/block/badblocks.c
>> @@ -16,6 +16,322 @@
>> #include <linux/types.h>
>> #include <linux/slab.h>
>>=20
>> +/*
>> + * The purpose of badblocks set/clear is to manage bad blocks ranges =
which are
>> + * identified by LBA addresses.
>> + *
>> + * When the caller of badblocks_set() wants to set a range of bad =
blocks, the
>> + * setting range can be acked or unacked. And the setting range may =
merge,
>> + * overwrite, skip the overlapped already set range, depends on who =
they are
>> + * overlapped or adjacent, and the acknowledgment type of the =
ranges. It can be
>> + * more complicated when the setting range covers multiple already =
set bad block
>> + * ranges, with restrictions of maximum length of each bad range and =
the bad
>> + * table space limitation.
>> + *
>> + * It is difficult and unnecessary to take care of all the possible =
situations,
>> + * for setting a large range of bad blocks, we can handle it by =
dividing the
>> + * large range into smaller ones when encounter overlap, max range =
length or
>> + * bad table full conditions. Every time only a smaller piece of the =
bad range
>> + * is handled with a limited number of conditions how it is =
interacted with
>> + * possible overlapped or adjacent already set bad block ranges. =
Then the hard
>> + * complicated problem can be much simpler to handle in proper way.
>> + *
>> + * When setting a range of bad blocks to the bad table, the =
simplified situations
>> + * to be considered are, (The already set bad blocks ranges are =
naming with
>> + *  prefix E, and the setting bad blocks range is naming with prefix =
S)
>> + *
>> + * 1) A setting range is not overlapped or adjacent to any other =
already set bad
>> + *    block range.
>> + *                         +--------+
>> + *                         |    S   |
>> + *                         +--------+
>> + *        +-------------+               +-------------+
>> + *        |      E1     |               |      E2     |
>> + *        +-------------+               +-------------+
>> + *    For this situation if the bad blocks table is not full, just =
allocate a
>> + *    free slot from the bad blocks table to mark the setting range =
S. The
>> + *    result is,
>> + *        +-------------+  +--------+   +-------------+
>> + *        |      E1     |  |    S   |   |      E2     |
>> + *        +-------------+  +--------+   +-------------+
>> + * 2) A setting range starts exactly at a start LBA of an already =
set bad blocks
>> + *    range.
>> + * 2.1) The setting range size < already set range size
>> + *        +--------+
>> + *        |    S   |
>> + *        +--------+
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + * 2.1.1) If S and E are both acked or unacked range, the setting =
range S can
>> + *    be merged into existing bad range E. The result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 2.1.2) If S is unacked setting and E is acked, the setting will =
be denied, and
>> + *    the result is,
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + * 2.1.3) If S is acked setting and E is unacked, range S can =
overwrite on E.
>> + *    An extra slot from the bad blocks table will be allocated for =
S, and head
>> + *    of E will move to end of the inserted range S. The result is,
>> + *        +--------+----+
>> + *        |    S   | E  |
>> + *        +--------+----+
>> + * 2.2) The setting range size =3D=3D already set range size
>> + * 2.2.1) If S and E are both acked or unacked range, the setting =
range S can
>> + *    be merged into existing bad range E. The result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 2.2.2) If S is unacked setting and E is acked, the setting will =
be denied, and
>> + *    the result is,
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + * 2.2.3) If S is acked setting and E is unacked, range S can =
overwrite all of
>> +      bad blocks range E. The result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 2.3) The setting range size > already set range size
>> + *        +-------------------+
>> + *        |          S        |
>> + *        +-------------------+
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + *    For such situation, the setting range S can be treated as two =
parts, the
>> + *    first part (S1) is as same size as the already set range E, =
the second
>> + *    part (S2) is the rest of setting range.
>> + *        +-------------+-----+        +-------------+       +-----+
>> + *        |    S1       | S2  |        |     S1      |       | S2  |
>> + *        +-------------+-----+  =3D=3D=3D>  +-------------+       =
+-----+
>> + *        +-------------+              +-------------+
>> + *        |      E      |              |      E      |
>> + *        +-------------+              +-------------+
>> + *    Now we only focus on how to handle the setting range S1 and =
already set
>> + *    range E, which are already explained in 2.2), for the rest S2 =
it will be
>> + *    handled later in next loop.
>> + * 3) A setting range starts before the start LBA of an already set =
bad blocks
>> + *    range.
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + *             +-------------+
>> + *             |      E      |
>> + *             +-------------+
>> + *    For this situation, the setting range S can be divided into =
two parts, the
>> + *    first (S1) ends at the start LBA of already set range E, the =
second part
>> + *    (S2) starts exactly at a start LBA of the already set range E.
>> + *        +----+---------+             +----+      +---------+
>> + *        | S1 |    S2   |             | S1 |      |    S2   |
>> + *        +----+---------+      =3D=3D=3D>   +----+      +---------+
>> + *             +-------------+                     +-------------+
>> + *             |      E      |                     |      E      |
>> + *             +-------------+                     +-------------+
>> + *    Now only the first part S1 should be handled in this loop, =
which is in
>> + *    similar condition as 1). The rest part S2 has exact same start =
LBA address
>> + *    of the already set range E, they will be handled in next loop =
in one of
>> + *    situations in 2).
>> + * 4) A setting range starts after the start LBA of an already set =
bad blocks
>> + *    range.
>> + * 4.1) If the setting range S exactly matches the tail part of =
already set bad
>> + *    blocks range E, like the following chart shows,
>> + *            +---------+
>> + *            |   S     |
>> + *            +---------+
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + * 4.1.1) If range S and E have same acknowledge value (both acked =
or unacked),
>> + *    they will be merged into one, the result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 4.1.2) If range E is acked and the setting range S is unacked, =
the setting
>> + *    request of S will be rejected, the result is,
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + * 4.1.3) If range E is unacked, and the setting range S is acked, =
then S may
>> + *    overwrite the overlapped range of E, the result is,
>> + *        +---+---------+
>> + *        | E |    S    |
>> + *        +---+---------+
>> + * 4.2) If the setting range S stays in middle of an already set =
range E, like
>> + *    the following chart shows,
>> + *             +----+
>> + *             | S  |
>> + *             +----+
>> + *        +--------------+
>> + *        |       E      |
>> + *        +--------------+
>> + * 4.2.1) If range S and E have same acknowledge value (both acked =
or unacked),
>> + *    they will be merged into one, the result is,
>> + *        +--------------+
>> + *        |       S      |
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
>> + *     loop and ignored in this loop.
>> + * 5) A setting bad blocks range S is adjacent to one or more =
already set bad
>> + *    blocks range(s), and they are all acked or unacked range.
>> + * 5.1) Front merge: If the already set bad blocks range E is before =
setting
>> + *    range S and they are adjacent,
>> + *                +------+
>> + *                |  S   |
>> + *                +------+
>> + *        +-------+
>> + *        |   E   |
>> + *        +-------+
>> + * 5.1.1) When total size of range S and E <=3D BB_MAX_LEN, and =
their acknowledge
>> + *    values are same, the setting range S can front merges into =
range E. The
>> + *    result is,
>> + *        +--------------+
>> + *        |       S      |
>> + *        +--------------+
>> + * 5.1.2) Otherwise these two ranges cannot merge, just insert the =
setting
>> + *    range S right after already set range E into the bad blocks =
table. The
>> + *    result is,
>> + *        +--------+------+
>> + *        |   E    |   S  |
>> + *        +--------+------+
>=20
> When I read here at the first time, I thought why there is not behind
> merge. After reading
> the following comments, it should be the 6.3, right?

Range E is for existed bad block range, and S is for inserting bad block =
range. So such situation is not handled by behind merge part.



>=20
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
>> + * 6.3) Behind merge: If the already set bad blocks range E is =
behind the setting
>> + *    range S and they are adjacent. Normally we don't need to care =
about this
>> + *    because front merge handles this while going though range S =
from head to
>> + *    tail, except for the tail part of range S. When the setting =
range S are
>> + *    fully handled, all the above simplified routine doesn't check =
whether the
>> + *    tail LBA of range S is adjacent to the next already set range =
and not able
>> + *    to them if they are mergeable.
> to merge them


Will update it in next version. Thanks.


>=20
>> + *        +------+
>> + *        |  S   |
>> + *        +------+
>> + *               +-------+
>> + *               |   E   |
>> + *               +-------+
>> + *    For the above special situation, when the setting range S are =
all handled
>> + *    and the loop ends, an extra check is necessary for whether =
next already
>> + *    set range E is right after S and mergeable.
>=20
> It's the codes in the update_sectors, right? It checks the p[prev] and =
p[prev+1]

Yes, it is the code block after the following comment,
/* Check whether the following already set range can be merged */

Like what combine_front() does, it tries to merge the ranges in bad =
blocks table into less ones, to avoid potential no-space issue in next =
time _badblocks_set() is called.

>=20
>> + * 6.2.1) When total size of range E and S <=3D BB_MAX_LEN, and =
their acknowledge
> 6.3.1
>=20
>> + *    values are same, the setting range S can behind merges into =
range E. The
>> + *    result is,
>> + *        +--------------+
>> + *        |       S      |
>> + *        +--------------+
>> + * 6.2.2) Otherwise these two ranges cannot merge, just insert the =
setting range
> 6.3.2

They will be updated in next version. Thanks.


>=20
>> + *     S in front of the already set range E in the bad blocks =
table. The result
>> + *     is,
>> + *        +------+-------+
>> + *        |  S   |   E   |
>> + *        +------+-------+
>> + *
>> + * All the above 5 simplified situations and 3 special cases may =
cover 99%+ of
>> + * the bad block range setting conditions. Maybe there is some rare =
corner case
>> + * is not considered and optimized, it won't hurt if badblocks_set() =
fails due
>> + * to no space, or some ranges are not merged to save bad blocks =
table space.
>> + *
>> + * Inside badblocks_set() each loop starts by jumping to re_insert =
label, every
>> + * time for the new loop prev_badblocks() is called to find an =
already set range
>> + * which starts before or at current setting range. Since the =
setting bad blocks
>> + * range is handled from head to tail, most of the cases it is =
unnecessary to do
>> + * the binary search inside prev_badblocks(), it is possible to =
provide a hint
>> + * to prev_badblocks() for a fast path, then the expensive binary =
search can be
>> + * avoided. In my test with the hint to prev_badblocks(), except for =
the first
>> + * loop, all rested calls to prev_badblocks() can go into the fast =
path and
>> + * return correct bad blocks table index immediately.
>> + */
>> +
>> /*
>>  * Find the range starts at-or-before 's' from bad table. The search
>>  * starts from index 'hint' and stops at index 'hint_end' from the =
bad
>> @@ -392,6 +708,230 @@ static int insert_at(struct badblocks *bb, int =
at, struct badblocks_context *bad
>>        return len;
>> }
>>=20
>> +static void badblocks_update_acked(struct badblocks *bb)
>> +{
>> +       bool unacked =3D false;
>> +       u64 *p =3D bb->page;
>> +       int i;
>> +
>> +       if (!bb->unacked_exist)
>> +               return;
>> +
>> +       for (i =3D 0; i < bb->count ; i++) {
>> +               if (!BB_ACK(p[i])) {
>> +                       unacked =3D true;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       if (!unacked)
>> +               bb->unacked_exist =3D 0;
>> +}
>> +
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
> Does it need to set prev to 0 here? It's -1 now. In update_sectors, it
> checks p[-1] and p[0].
> I guess it should check p[0] and [1].

Nice catch! I=E2=80=99d like to add a check (prev >=3D 0) after =
update_sectors, if there is potential merge, it can be handled by =
combine_front() in next loop.


>=20
>> +                       goto update_sectors;
>> +               }
>> +
>> +               /* No sapce, try to merge */
>> +               if (overlap_behind(bb, &bad, 0)) {
>> +                       if (can_merge_behind(bb, &bad, 0)) {
>> +                               len =3D behind_merge(bb, &bad, 0);
>> +                               added++;
>> +                       } else {
>> +                               len =3D min_t(sector_t,
>> +                                           BB_OFFSET(p[0]) - s, =
sectors);
>=20
> It doesn't need to check min_t here. sectors must be >=3D =
(BB_OFFSET(p[0] - s))

Yes, it can be simplified.

>=20
>> +                               space_desired =3D 1;
>> +                       }
>> +                       hint =3D 0;
>=20
> prev=3D0?

I will add a check for prev < 0 after update_sectors label.


>=20
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
>=20
> When I'm here. I have a confused question. Why we need front_combine?
> It looks like
> front_merge can do this job too. In front_combine, it needs bad->start
> =3D=3D BB_OFFSET(p[prev]).
> Why does it need this judgement?


I replied in previous patch. front_combine() is to handle a special =
condition, and try to merge more bad block ranges from the bad blocks =
table.

Thanks for your comments. I will post an update version for your further =
code review.

Coly Li


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
>> +       /* Check whether the following already set range can be =
merged */
>> +       if ((prev + 1) < bb->count &&
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
>> +               bb->count--;
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
>> +
>> +       return rv;
>> +}
>> +
>> /**
>>  * badblocks_check() - check a given range for bad sectors
>>  * @bb:                the badblocks structure that holds all =
badblock information
>> @@ -501,26 +1041,6 @@ int badblocks_check(struct badblocks *bb, =
sector_t s, int sectors,
>> }
>> EXPORT_SYMBOL_GPL(badblocks_check);
>>=20
>> -static void badblocks_update_acked(struct badblocks *bb)
>> -{
>> -       u64 *p =3D bb->page;
>> -       int i;
>> -       bool unacked =3D false;
>> -
>> -       if (!bb->unacked_exist)
>> -               return;
>> -
>> -       for (i =3D 0; i < bb->count ; i++) {
>> -               if (!BB_ACK(p[i])) {
>> -                       unacked =3D true;
>> -                       break;
>> -               }
>> -       }
>> -
>> -       if (!unacked)
>> -               bb->unacked_exist =3D 0;
>> -}
>> -
>> /**
>>  * badblocks_set() - Add a range of bad blocks to the table.
>>  * @bb:                the badblocks structure that holds all =
badblock information
>> --
>> 2.31.1
>>=20
>=20

