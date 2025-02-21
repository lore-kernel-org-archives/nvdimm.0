Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8269D20767F
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134692; cv=none; b=PvsarpwqN11TW+XC3voFc0lPBp6Qjqyg8quZOL8u1eG4EeGA4if9rWzGNsZk0UdjCwp+kOvO4GiJUGegksIMLo3F8DBHclT5MskmRSizYgZOI/gzNOx3Z+L2H4KJSmcw27WUYbv2c0ht9mMxmPC8F9Ggm6YbJNtnhgRnDkVr7FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134692; c=relaxed/simple;
	bh=UUdEecgDqSQ3SckRw+rCo/MjrBAF0Kh1OxWA5Kqg7hY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=XiG/ObWIOqnUtI/+bmzDi+D7eXL95aegiSQiiygPAg5oQRlpYJy+JayGLhBH/DePIMYnGfoNxFTw+RDLySaoZEP3x55El6kY1hl0FVp5AErBuEdR24J5lUgJP7CB3pzjZC7wcA1L+s+NtPgs82Pezt3qUQCsjObQs4/kt57tINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gR85HG77; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gR85HG77"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250221104441epoutp03f558f2e225fc1f0e8772804fb1e1f135~mM0X3cZ9v1685016850epoutp03f
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 10:44:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250221104441epoutp03f558f2e225fc1f0e8772804fb1e1f135~mM0X3cZ9v1685016850epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740134681;
	bh=zq2OvmombF/nmjIv8d+NCP6My+EYDfaxUFB90IcnD0c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gR85HG770K8U6Ihp65qDxI/1hlL65U/OlnDi0Qm2+OFXknrlnI3WkWxDer23EMu2H
	 zrw4J9IkmOZXXXAMKPMcE/bV/tro81BsrcGCRg0OFKQhKLmQHc0Laq+cUWQnrXcxrO
	 vm75V6Xl1FFZAQhOIulhchSPqZ0UnL7Tj7x6Q8E0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250221104441epcas5p2457463accd4a08408833736bca205105~mM0XczCh01679816798epcas5p2J;
	Fri, 21 Feb 2025 10:44:41 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4YzmwQ70B1z4x9Pr; Fri, 21 Feb
	2025 10:44:38 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	43.65.19933.61958B76; Fri, 21 Feb 2025 19:44:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250221104410epcas5p384409475a9ae988d52d04c424fe70df3~mMz6cUQ_A0563805638epcas5p3E;
	Fri, 21 Feb 2025 10:44:10 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250221104410epsmtrp1b1ff0c3a4683e6b3dad47bf9642e04b0~mMz6bjF5z0516605166epsmtrp1a;
	Fri, 21 Feb 2025 10:44:10 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-38-67b85916a399
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DD.16.18949.9F858B76; Fri, 21 Feb 2025 19:44:09 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250221104408epsmtip2fbc853b37f2f4278a1203c413b5d60ce~mMz4jcIUj1068210682epsmtip2x;
	Fri, 21 Feb 2025 10:44:07 +0000 (GMT)
Date: Fri, 21 Feb 2025 16:05:54 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig
	<hch@lst.de>, M Nikhil <nikh1092@linux.ibm.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-scsi@vger.kernel.org, hare@suse.de, steffen Maier
	<maier@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>, Nihar Panda
	<niharp@linux.ibm.com>
Subject: Re: Change in reported values of some block integrity sysfs
 attributes
Message-ID: <20250221103554.GA28830@green245>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CACzX3AvbM4qG+ZOWJoCTNMMgSz8gMjoRcQ10_HJbMyi0Nv9qvQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmuq5Y5I50gy9tFhYfv/5msbi07gKz
	xYJFc1ks9iyaxGSxcvVRJou9t7Qt2ufvYrTovr6DzeJi71dmi+XH/zFZfOv4yG5x9+JTZouV
	P/6wOvB67Jx1l91jwqIDjB4vNs9k9Nh9s4HN4+PTWywem09Xe3zeJBfAHpVtk5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	zqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2PKylNsBRclK3b2
	f2JpYDwn0sXIwSEhYCKx4IF2FyMXh5DAbkaJV++vMEM4nxglDv+4wwbhfGOUmPptOXsXIydY
	x/+t01kgEnsZJW70tkJVPWOU2HDkCitIFYuAqsSPJwvAOtgE1CWOPG9lBLFFBNQknm7bDtbA
	LNDJLDGtcwobSEJYIFDi64bfYEW8AroSy+5shLIFJU7OfMICYnMC1Xz53swMYosKKEsc2Hac
	CWSQhMAODoklby6wQdznIjH11AEmCFtY4tXxLVB3S0m87G+DstMlflx+ClVTINF8bB8jhG0v
	0XqqH2wBs0CGxJnWO1A1skAz1zFBxPkken8/gYrzSuyYB2MrSbSvnANlS0jsPdcAZXtIfNl9
	EWymkEALk0TTdaYJjPKzkPw2C8k6CFtHYsHuT2yzgBHELCAtsfwfB4SpKbF+l/4CRtZVjJKp
	BcW56anFpgVGeanl8BhPzs/dxAhOzFpeOxgfPvigd4iRiYPxEKMEB7OSCG9b/ZZ0Id6UxMqq
	1KL8+KLSnNTiQ4ymwMiayCwlmpwPzA15JfGGJpYGJmZmZiaWxmaGSuK8zTtb0oUE0hNLUrNT
	UwtSi2D6mDg4pRqY4j4/5ncud7LMVXZ2YuzsXOv1qv/BSp4767M2PL14X1CXh/FjusCHjtSK
	LVcfT5+4sZ5pT1iBStKlLZ5s3qd2WPrVcnMVnLlwnPNyRI+phQ6b7P+2T6x2K5ZLpzG8YXh1
	94OvxoKYl6J+9yrsH7j6GRmpKobfFJ85jX8qr+92N9vj+wzeLVvKfaStftfEqa/3v0wKmD0x
	qbpsqs+RZuP2HYzn5KY0CuSyl+SpaFo26Io4vLb13HnVVaw2tV7tYtP+8LC0j482rGWsSmR9
	qFRXlNqZbhzuw3RP63rON/F5s17kp3F/y5/2SD1xkZOv4/Fz9uETwvvcutyrY262KW7J/yO5
	vfFc6uGonzMVrimxFGckGmoxFxUnAgDXBQJ2VQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LZdlhJXvdnxI50gwm7TS0+fv3NYnFp3QVm
	iwWL5rJY7Fk0icli5eqjTBZ7b2lbtM/fxWjRfX0Hm8XF3q/MFsuP/2Oy+Nbxkd3i7sWnzBYr
	f/xhdeD12DnrLrvHhEUHGD1ebJ7J6LH7ZgObx8ent1g8Np+u9vi8SS6APYrLJiU1J7MstUjf
	LoEr48GxWWwFE8UrNvX0MTcwLhfqYuTkkBAwkfi/dTpLFyMXh5DAbkaJIz/72SASEhKnXi5j
	hLCFJVb+e84OUfSEUeLP5QZWkASLgKrEjycL2EFsNgF1iSPPW8EaRATUJJ5u284G0sAs0M0s
	sXTzfhaQhLBAoMTXDb/BingFdCWW3dnICDG1hUli+6YbrBAJQYmTM5+ANTALaEnc+PeSqYuR
	A8iWllj+jwMkzAk058v3ZmYQW1RAWeLAtuNMExgFZyHpnoWkexZC9wJG5lWMkqkFxbnpucWG
	BUZ5qeV6xYm5xaV56XrJ+bmbGMExpaW1g3HPqg96hxiZOBgPMUpwMCuJ8LbVb0kX4k1JrKxK
	LcqPLyrNSS0+xCjNwaIkzvvtdW+KkEB6YklqdmpqQWoRTJaJg1OqgWlZhm/JQ2udY28LzZZY
	Cu/gv7F4kvTaFqbvTnpnBZTdi/d01iQeeXFPM7BqUtOXuohKE7HMgmUK3w+LzP8zx69RMzdh
	zSl7tT1zE7a8jth+ze3txt/aOcw/5256fZzvwmLL558O2LeFKDKFBk3T0n5stvXm6V2rI4TD
	F8tp+ZyQfSPMacbCmeMf8chakW1lddXa+HvH124MuuKclMeUsf1Ddv6rr1FZnxyXFn1K5JFJ
	LP4/b+Mdt26tjIlnFS/W2mgGfpdPSLR91tM3QSvClyHixNn0qtfMyeyNrBMer9skXDW/lE2/
	df4p7lOsRX+qLMJ3s22peXI+uMX1S/eV809kApbMdts3ozv3pILadyWW4oxEQy3mouJEAJRQ
	CnwYAwAA
X-CMS-MailID: 20250221104410epcas5p384409475a9ae988d52d04c424fe70df3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_7482b_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250221103836epcas5p2158071e3449f10b80b44b43595d18704
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
	<yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
	<CGME20250221103836epcas5p2158071e3449f10b80b44b43595d18704@epcas5p2.samsung.com>
	<CACzX3AvbM4qG+ZOWJoCTNMMgSz8gMjoRcQ10_HJbMyi0Nv9qvQ@mail.gmail.com>

------MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_7482b_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Fri, Feb 21, 2025 at 04:07:55PM +0530, Anuj gupta wrote:
> > I don't see any change in what's reported with block/for-next in a
> > regular SCSI HBA/disk setup. Will have to look at whether there is a
> > stacking issue wrt. multipathing.
> 
> Hi Martin, Christoph,
> 
> It seems this change in behaviour is not limited to SCSI only. As Nikhil
> mentioned an earlier commit
> [9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")]
> causes this change in behaviour. On my setup with a NVMe drive not formatted
> with PI, I see that:
> 
> Without this commit:
> Value reported by read_verify and write_generate sysfs entries is 0.
> 
> With this commit:
> Value reported by read_verify and write_generate sysfs entries is 1.
> 
> Diving a bit deeper, both these flags got inverted due to this commit.
> But during init (in nvme_init_integrity) these values get initialized to 0,
> inturn setting the sysfs entries to 1. In order to fix this, the driver has to
> initialize both these flags to 1 in nvme_init_integrity if PI is not supported.
> That way, the value in sysfs for these entries would become 0 again. Tried this
> approach in my setup, and I am able to see the right values now. Then something
> like this would also need to be done for SCSI too.

This is the patch that I used:

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 818d4e49aab5..6cd9f57131cc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1799,6 +1799,7 @@ static bool nvme_init_integrity(struct nvme_ns_head *head,
 
 	memset(bi, 0, sizeof(*bi));
 
+	bi->flags |= BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
 	if (!head->ms)
 		return true;
 
@@ -1817,11 +1818,15 @@ static bool nvme_init_integrity(struct nvme_ns_head *head,
 			bi->csum_type = BLK_INTEGRITY_CSUM_CRC;
 			bi->tag_size = sizeof(u16) + sizeof(u32);
 			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
+			bi->flags &= ~(BLK_INTEGRITY_NOGENERATE |
+				       BLK_INTEGRITY_NOVERIFY);
 			break;
 		case NVME_NVM_NS_64B_GUARD:
 			bi->csum_type = BLK_INTEGRITY_CSUM_CRC64;
 			bi->tag_size = sizeof(u16) + 6;
 			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
+			bi->flags &= ~(BLK_INTEGRITY_NOGENERATE |
+				       BLK_INTEGRITY_NOVERIFY);
 			break;
 		default:
 			break;
@@ -1835,12 +1840,16 @@ static bool nvme_init_integrity(struct nvme_ns_head *head,
 			bi->tag_size = sizeof(u16);
 			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
 				     BLK_INTEGRITY_REF_TAG;
+			bi->flags &= ~(BLK_INTEGRITY_NOGENERATE |
+				       BLK_INTEGRITY_NOVERIFY);
 			break;
 		case NVME_NVM_NS_64B_GUARD:
 			bi->csum_type = BLK_INTEGRITY_CSUM_CRC64;
 			bi->tag_size = sizeof(u16);
 			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
 				     BLK_INTEGRITY_REF_TAG;
+			bi->flags &= ~(BLK_INTEGRITY_NOGENERATE |
+				       BLK_INTEGRITY_NOVERIFY);
 			break;
 		default:
 			break;


------MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_7482b_
Content-Type: text/plain; charset="utf-8"


------MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_7482b_--
