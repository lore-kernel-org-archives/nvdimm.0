Received: from mail03.softline.ru (mail03.softline.ru [185.31.132.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F3222D61
	for <nvdimm@lists.linux.dev>; Thu, 19 Dec 2024 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.31.132.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734604223; cv=none; b=Nc/+U13u3G/AZc4akduBQTap+zoOE2BS08SsPCRo3NnJY5swJSxZfOKlDJsDYym+wdzzspIhFbthKvSp7s73qvhaSNgJ4qUWzUlTit+uZtcWIhnh4ooMaHtfXCQvXins25/uS1dQeXU2vbHWYcoMDyz9ChJv7DCkTlDVvUhg35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734604223; c=relaxed/simple;
	bh=nnjI8zbgRlcM0n7d5HF0lTxFjjRVuYvPKUej+EKUn9o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q4NeG+v8i7IyiiwfvoGZjF+S+8xd4aQWGMFzrc3/yCfQdJJjfTq5BR4x+Hz5T58XMTidTGyl4PZcuFHtJ6dJki3npsbW5t1TIj+IcBkmPYffxdZGYy8OBkrBes4r08RjBxANU6eELeqrwncWc9+xzqckuJnRbKYLiHRI3FiNPEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=softline.com; spf=pass smtp.mailfrom=softline.com; dkim=pass (2048-bit key) header.d=softline.com header.i=@softline.com header.b=keIw7v1N; arc=none smtp.client-ip=185.31.132.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=softline.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=softline.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=softline.com header.i=@softline.com header.b="keIw7v1N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=softline.com;
	s=relay; t=1734603408;
	bh=nnjI8zbgRlcM0n7d5HF0lTxFjjRVuYvPKUej+EKUn9o=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=keIw7v1NbDhXuCaDGCFIG99AmoGW48xKeTSQHdNN29qL1RmOV7RSv9rVPTZYRKe8d
	 sjBFoAhuPVqDu9ht/i4OeXOS/uGnRTM32PkrPK6V+icBvFz4t8jd6+sMN5xq8ERxBw
	 nrReLC9ZQE41IT53XWlhXAAMfrnGmL2b7/h0SZcPoYvF9tADvc7f+kUxrrA5/1HUQK
	 WT/VuE8rCDlu4uIzpVUayHiQjGY2O44PNGVQ25GONFIGabkvNf8Q3AEUhVsNl+NY/s
	 gQyANMAiffJFNmvv4Ib4yxny0M1aI1+gqANwvku2aP+u1QT3ILEPLthioUMfDGd8pv
	 pIWYWc2p0uPKA==
From: "Antipov, Dmitriy" <Dmitriy.Antipov@softline.com>
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"dmantipov@yandex.ru" <dmantipov@yandex.ru>, "dave.jiang@intel.com"
	<dave.jiang@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>
CC: "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [lvc-project] [PATCH] nvdimm: add extra LBA check for map read
 and write operations
Thread-Topic: [lvc-project] [PATCH] nvdimm: add extra LBA check for map read
 and write operations
Thread-Index: AQHbUZxs2DJKksaLl0eLFwwqKTZuibLtKLMA
Date: Thu, 19 Dec 2024 10:16:47 +0000
Message-ID: <8991bbec45144eb9a74319131fcbe1e579600036.camel@softline.com>
References: <20241216123712.297722-1-dmantipov@yandex.ru>
	 <67634cd49d098_2c1f7929481@iweiny-mobl.notmuch>
In-Reply-To: <67634cd49d098_2c1f7929481@iweiny-mobl.notmuch>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <B36DF11A46D9F94C9BB2CFD646A29CD5@softline.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTEyLTE4IGF0IDE2OjI5IC0wNjAwLCBJcmEgV2Vpbnkgd3JvdGU6DQoNCj4g
RG9lcyB0aGlzIGZpeCBhIHJlYWwgcHJvYmxlbT8NCg0KTm9uZSBhcyBJJ20gYXdhcmUgb2YuIEJ1
dCBncm93aW5nIE5WRElNTSBzaXplcyBtYXkgYmUgYSBwcm9ibGVtIGZvciB1MzINCnJhbmdlLiBJ
TUhPIG1haW50YWluZXJzIGFyZSBiZXR0ZXIgdG8gYmUgcHJlcGFyZWQgZm9yIHN1Y2ggYSBzY2Vu
YXJpby4NCg0KRG1pdHJ5DQo=
