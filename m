Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: NeilBrown <neilb@suse.com>
Date: Fri, 01 Apr 2016 11:34:56 +1100
Subject: Re: [PATCH 12/12] dax: New fault locking
In-Reply-To: <20160331085449.GB11041@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz> <1457637535-21633-13-git-send-email-jack@suse.cz> <87h9gdj3dt.fsf@notabene.neil.brown.name> <87egbbh1cr.fsf@notabene.neil.brown.name> <20160318141618.GF7152@quack.suse.cz> <20160318153919.GG7152@quack.suse.cz> <87h9fycj71.fsf@notabene.neil.brown.name> <20160323110011.GD4512@quack.suse.cz> <87oa9vs2hb.fsf@notabene.neil.brown.name> <20160331085449.GB11041@quack.suse.cz>
Message-ID: <87oa9uqi8f.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31 2016, Jan Kara wrote:

> On Thu 31-03-16 15:20:00, NeilBrown wrote:
>> On Wed, Mar 23 2016, Jan Kara wrote:
>>=20

>> > But how does this really help? If lookup_unlocked_mapping_entry() finds
>> > there is no entry (and it was there before), the process deleting the =
entry
>> > (or replacing it with something else) is responsible for waking up
>> > everybody.
>>=20
>> "everybody" - yes.  But it doesn't wake everybody does it?  It just
>> wakes one.
>>=20
>> +		__wake_up(wq, TASK_NORMAL, 1, &key);
>>                                            ^one!
>>=20
>> Or am I misunderstanding how exclusive waiting works?
>
> Ah, OK. I have already fixed that in my local version of the patches so
> that we wake-up everybody after deleting the entry but forgot to tell you.
> So I have there now:
>
> 		__wake_up(wq, TASK_NORMAL, 0, &key);

"0" meaning "MAX_INT+1" (or something).  I didn't realize you could do
that, but it makes perfect sense.

>
> Are you OK with the code now?

Certainly less unhappy.  Assume that I am OK but I'll try to have
another look when you post again and make sure any lingering doubts are
gone.

Thanks,
NeilBrown


>
> 								Honza
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/cIwAAoJEDnsnt1WYoG5kGUQALop5KpnCN+YoMcvSfZpcO4n
Ss3k8U/fk16Yw+W0vrcFcbazFcPBCdCHOAYXNQnLw2IqfE00HdBe/IiSo5ndcFTG
HV4AU4PeZw0bB96k5p0aHsnnIkAcv95OQslcC2kcbnPNx8UTleQG6cqLb6QQuxVT
bGeHPwV9id31Ks3MGqJncqebFw0LipJ+VIl7bLGA4yprYYoxnYJW/QaTcf6Sa7VX
/kxZ5rfSYMX9uKjuvE7QACVUV7Z0m5Yci6b/YX/wQTOopckHozFz50qWekcNsoyt
w8WhFvyNdfiCFLjBNq9aKrHzlkqs0HHWeod3b7cR3HiOqS5of+tO9rX5bq2/8dVu
mYLO2Z6lKPhIw2BfrM0kt2xuvsSVdFizJccVaj0BOKZvgA/Fyt3h6cd19s07Vhrv
Q0FAduYuiRCNCZsG84RFwhFwSAoCf973CDK7OWdhLYoTh5pWD9w85rbLsoPOllm7
naH0m6JDytWTCXFLYwPExl37u1dfLCDWfgBngA0vNhtHztTKGGpZkI+nPD/qYYN9
0IIT0MZoCYMNKHgnjJu9CrR6Hmbp89RTj34s3WozCD4/cD+bzwKtfutEKw4HXV4B
OV1HKY1LMOPVZOyIYa81tDIQjiL37FBbFpo3FG57laROutOHtk0R7nuBa7RGaMmr
xktDpB8QB5uh+DyvKZp1
=tDMz
-----END PGP SIGNATURE-----
--=-=-=--
