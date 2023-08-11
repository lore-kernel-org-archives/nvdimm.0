Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9EE1173F
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 16:57:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 581971F8AB;
	Fri, 11 Aug 2023 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1691773050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WRMLThMjRnza6cY+sDsGfPzEUxyI8oSxa4duiWVd80k=;
	b=FbghrOIzbDN1yL/stHy7oCD0VkDUWJbv4AEqVn9m6pzODdQvGSXgFRDQv0jlC/SeXEH3Wt
	YSC4S/7Fq9lSWL/YEc/oQHACvD8u5aRLBHpLzC8Y2qsa7nryieSffXoQucaKW0JTqVzdKx
	dvX43/lEaj3uxepwMJ5e+/4uW2duKYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1691773050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WRMLThMjRnza6cY+sDsGfPzEUxyI8oSxa4duiWVd80k=;
	b=sdPW/gvd4gu6Bh/BZ4mogeA1QXfLjy21xWdAWfW8TEH5gDNIc08oWYL7Rj+cnyMahkgIT1
	8zrA4vKXTD/z+cAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 568E4138E2;
	Fri, 11 Aug 2023 16:57:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id A8ZrCnho1mSwVAAAMHmgww
	(envelope-from <colyli@suse.de>); Fri, 11 Aug 2023 16:57:28 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH v6 2/7] badblocks: add helper routines for badblock ranges
 handling
From: Coly Li <colyli@suse.de>
In-Reply-To: <CALTww2-Y6b+Ruqsux9e2gXSngzGioTwENAFsygj5Rbgipgy0wg@mail.gmail.com>
Date: Sat, 12 Aug 2023 00:57:15 +0800
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
Message-Id: <C64D4553-13AC-4337-B7DA-8C68B85E0C91@suse.de>
References: <20220721121152.4180-1-colyli@suse.de>
 <20220721121152.4180-3-colyli@suse.de>
 <CALTww2-Y6b+Ruqsux9e2gXSngzGioTwENAFsygj5Rbgipgy0wg@mail.gmail.com>
To: Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3731.600.7)



> 2022=E5=B9=B49=E6=9C=8821=E6=97=A5 20:13=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A

[snipped]

>>=20
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
>=20
> Is it better to check something like this:
>=20
> if (BB_OFFSET(p[lo]) > s)
>   return ret;


Yeah, it is worthy to add such check to avoid the following bisect =
search, if lucky.
Will do it in next version.

>=20
>> +
>> +       while (hi - lo > 1) {
>> +               int mid =3D (lo + hi)/2;
>> +               sector_t a =3D BB_OFFSET(p[mid]);
>> +
>> +               if (a =3D=3D s) {
>> +                       ret =3D mid;
>> +                       goto out;
>> +               }
>> +
>> +               if (a < s)
>> +                       lo =3D mid;
>> +               else
>> +                       hi =3D mid;
>> +       }
>> +
>> +       if (BB_OFFSET(p[lo]) <=3D s)
>> +               ret =3D lo;
>> +out:
>> +       return ret;
>> +}
>> +

[snipped]

>>=20
>> +/*
>> + * Combine the bad ranges indexed by 'prev' and 'prev - 1' (from bad
>> + * table) into one larger bad range, and the new range is indexed by
>> + * 'prev - 1'.
>> + */
>> +static void front_combine(struct badblocks *bb, int prev)
>> +{
>> +       u64 *p =3D bb->page;
>> +
>> +       p[prev - 1] =3D BB_MAKE(BB_OFFSET(p[prev - 1]),
>> +                             BB_LEN(p[prev - 1]) + BB_LEN(p[prev]),
>> +                             BB_ACK(p[prev]));
>> +       if ((prev + 1) < bb->count)
>> +               memmove(p + prev, p + prev + 1, (bb->count - prev - =
1) * 8);
>            else
>                    p[prev] =3D 0;

The caller of front_combine() will decrease bb->count by 1, so clearing =
p[prev] here can be avoided. I will add code comments of front_combine =
to explain this.
Thanks.

[snipped]

>> +/*
>> + * Return 'true' if the range indicated by 'bad' can overwrite the =
bad
>> + * range (from bad table) indexed by 'prev'.
>> + *
>> + * The range indicated by 'bad' can overwrite the bad range indexed =
by
>> + * 'prev' when,
>> + * 1) The whole range indicated by 'bad' can cover partial or whole =
bad
>> + *    range (from bad table) indexed by 'prev'.
>> + * 2) The ack value of 'bad' is larger or equal to the ack value of =
bad
>> + *    range 'prev'.
>=20
> In fact, it can overwrite only the ack value of 'bad' is larger than
> the ack value of the bad range 'prev'.
> If the ack values are equal, it should do a merge operation.

Yes you are right, if extra is 0, it is indeed a merge operation. And if =
extra is 1, or 2, it means bad blocks range split, I name such situation =
as overwrite.

[snipped]


>> +/*
>> + * Do the overwrite from the range indicated by 'bad' to the bad =
range
>> + * (from bad table) indexed by 'prev'.
>> + * The previously called can_front_overwrite() will provide how many
>> + * extra bad range(s) might be split and added into the bad table. =
All
>> + * the splitting cases in the bad table will be handled here.
>> + */
>> +static int front_overwrite(struct badblocks *bb, int prev,
>> +                          struct badblocks_context *bad, int extra)
>> +{
>> +       u64 *p =3D bb->page;
>> +       sector_t orig_end =3D BB_END(p[prev]);
>> +       int orig_ack =3D BB_ACK(p[prev]);
>> +
>> +       switch (extra) {
>> +       case 0:
>> +               p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]), =
BB_LEN(p[prev]),
>> +                                 bad->ack);
>> +               break;
>> +       case 1:
>> +               if (BB_OFFSET(p[prev]) =3D=3D bad->start) {
>> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
>> +                                         bad->len, bad->ack);
>> +                       memmove(p + prev + 2, p + prev + 1,
>> +                               (bb->count - prev - 1) * 8);
>> +                       p[prev + 1] =3D BB_MAKE(bad->start + =
bad->len,
>> +                                             orig_end - =
BB_END(p[prev]),
>> +                                             orig_ack);
>> +               } else {
>> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
>> +                                         bad->start - =
BB_OFFSET(p[prev]),
>> +                                         BB_ACK(p[prev]));
>=20
> s/BB_ACK(p[prev])/orig_ack/g

Yeah, this one is better. I will use it in next version.


>> +                       /*
>> +                        * prev +2 -> prev + 1 + 1, which is for,
>> +                        * 1) prev + 1: the slot index of the =
previous one
>> +                        * 2) + 1: one more slot for extra being 1.
>> +                        */
>> +                       memmove(p + prev + 2, p + prev + 1,
>> +                               (bb->count - prev - 1) * 8);
>> +                       p[prev + 1] =3D BB_MAKE(bad->start, bad->len, =
bad->ack);
>> +               }
>> +               break;
>> +       case 2:
>> +               p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
>> +                                 bad->start - BB_OFFSET(p[prev]),
>> +                                 BB_ACK(p[prev]));
>=20
> s/BB_ACK(p[prev])/orig_ack/g

It will be used in next version.

>=20
>> +               /*
>> +                * prev + 3 -> prev + 1 + 2, which is for,
>> +                * 1) prev + 1: the slot index of the previous one
>> +                * 2) + 2: two more slots for extra being 2.
>> +                */
>> +               memmove(p + prev + 3, p + prev + 1,
>> +                       (bb->count - prev - 1) * 8);
>> +               p[prev + 1] =3D BB_MAKE(bad->start, bad->len, =
bad->ack);
>> +               p[prev + 2] =3D BB_MAKE(BB_END(p[prev + 1]),
>> +                                     orig_end - BB_END(p[prev + 1]),
>> +                                     BB_ACK(p[prev]));
>=20
> s/BB_ACK(p[prev])/orig_ack/g


It will be used in next version.


>> +               break;
>> +       default:
>> +               break;
>> +       }
>> +
>> +       return bad->len;
>> +}
>> +
>> +/*

Thank you for the review!

Coly Li

