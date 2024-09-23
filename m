Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CD512CDB6;
	Mon, 23 Sep 2024 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727104677; cv=none; b=itucB6irYMcpQHHMUOvmstBPZrw3CQLTlCJDhAPKIvl23+R3+jRZg4yY0zajaIepsXjYvSMRX+9hqPWVM8LGQR4TTOO4RYNB1XlpB67QsDXRNv5Oq4VTMD25J9mnlf8wjLkG9QcFgpo11o/b101LrxpnGGm39uborFMDoZzua0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727104677; c=relaxed/simple;
	bh=yG8AvyiyRP5u3+5MM4OvFIqzHE1uXD8tmtbV+ly49xI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=QuQO8CP6M5Ia0vWNk6WaxRE3PjQE0RQgFzE3liuV90cVfbRFmQO8SJoBfdKCsINeGjccrrs5o+AQkCR6qBf4vwGjrbsbtfDiggg0s15yX41dFk2DAi4rKgWBIWhRN0sWLVo8JDly/pxDp0xlvzKFd8JXi9VmUIMoyjSBGhixA6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=AQf8hGkT; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="AQf8hGkT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1727104662; x=1727709462; i=markus.elfring@web.de;
	bh=xAMBgY9rGgoaR+LD1HXkmIq4mkMiYynQ4+4OcyBbevg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=AQf8hGkTPAS57uNusN0UdsplvH8Ns1k2oVLI18xlPtYjBNwmJvKCHSNAyy4RFraQ
	 hYHcuFM2/uXFbbgyzBNqmScS+20mij4QAb+sM9KGS6C8kzdJ3dKJtCO6lqkkmDoze
	 4CEgwVMzXM9+ZW0e/1x2QVsXSlYVzCxQjlIBEA1iPN2LylZmgd3GkFqqkV8ubl01b
	 fLDUye+kKu4U/Jctnlq5SRWPOtHb09E7WylpvXyyS62qwIA2apcTgZd7MrxvillmR
	 c/l7crDolFZ8X3NAEtFhbLffR/qRhYxxhlXYFRa2r5SoRQv+WR8KuqoRc/302l7Uy
	 mEkJop0NJW1XHayQwA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.90.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MMGyK-1scrrM0I46-00Vnsi; Mon, 23
 Sep 2024 17:17:42 +0200
Message-ID: <d4e3550f-3c50-41f8-a6ed-dd689b2ae868@web.de>
Date: Mon, 23 Sep 2024 17:17:29 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: nvdimm@lists.linux.dev, kernel-janitors@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] nvdimm: Call nvdimm_put_key(key) only once in
 nvdimm_key_revalidate()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VF7p49MuxkY8KK/+835nqEHjxWIxBGdrEo9OwVO8q9EfY1AobB0
 eR0SX6rDij5Bina2F/ag/P+2aJHpKgvF/TJbQpMMr+ek87nEr3t9sBN5xtK93zCM2umtoLP
 Lr7btV85YkCrVRX0UuwiOHDXiHS4PZKbvNzk/CI5ewTrKw5UU8h4z3VHQbqGFhijK3G+YwA
 FzOJRXwvRqhdY6EN+b4mQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dXDkJNmOHFk=;DwZwlhMCkHMjeJSd6Nj1edmkDaB
 XzlhPaSccn5BvMvjpgSEi/sqJYHzNP72Boz8YDKxCyhKCt6NV59iUyTleRavQKSo6pxIzBlU5
 Jw4AZScblxOxHp190JcC4nz9IaMyJu8MwrXvXICaHRA2hIo+n4q7+23FAfGQAJFWPcqp7PO0n
 ZdK+t9l749WVgzVTka/kmVb6tb3vzC2vf8OlUPYcv7fCCLS4Z6o0aIs4zE/2qJdwwpeXALhMz
 76mkXSfMp/Dm5EB0Un4JdsmlUJ9AKN19U3YcmLL3f+mDl0NmIb05AbR+iQKmA6Bz8PgLg+AbP
 khjCHaFffkmY8UWfaJ/S+L1uNthnlMr8EEMouvZBwjwzlBLtFqTezR2mX9gxQnFihosfH6Qth
 nGVwO6cNip547uOsuOnP6G5I2xlIKNTcpWcVAWvVFih0QlZ4RwzvRibKiHzwlkM90ahHEjtpX
 +RBm/4ITGLHQ4GfzjNqFwwcdXcVIxjpUu2095lcZRbUyFGm+jGVzuhwrB5fPIAsu71OH4aWc5
 buOCOWCyBpJIJ5aiEbJ5F66YmSxtUJ01kz4D7XIsG+fOk8+mY+3mx0Cp+l5YxlvLouw2D7SaS
 PUWupHdl7Fm7s3kOg/LeIt+ek/kmjlFFr9/Q/1flFSnINGiq3bZaQzapKyCjPgyntCTbvRZwh
 jnKk0izoLIKU/VYVK51VxAogciVVuwaUphgVtpzqRO5Fceu7Gk5VYAcxbgLAKWxWxZB55c47Y
 kRog/IxAB6Yru2Z7LWgu1YpwyI9PrBFAOgcoWx7OoJShtJ5w20vSjVsVI6+7wwna67Gk0p0G6
 8iq6AMing5sbBeIDaPmEAwTw==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 23 Sep 2024 17:05:39 +0200

A nvdimm_put_key(key) call was immediately used after a return code
check for a change_key() call in this function implementation.
Thus call such a function only once instead directly before the check.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/nvdimm/security.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index a03e3c45f297..83c30980307c 100644
=2D-- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -152,12 +152,10 @@ static int nvdimm_key_revalidate(struct nvdimm *nvdi=
mm)
 	 * verify that the key is good.
 	 */
 	rc =3D nvdimm->sec.ops->change_key(nvdimm, data, data, NVDIMM_USER);
-	if (rc < 0) {
-		nvdimm_put_key(key);
+	nvdimm_put_key(key);
+	if (rc < 0)
 		return rc;
-	}

-	nvdimm_put_key(key);
 	nvdimm->sec.flags =3D nvdimm_security_flags(nvdimm, NVDIMM_USER);
 	return 0;
 }
=2D-
2.46.1

