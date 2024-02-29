Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2749446C9
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 23:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.147.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709248924; cv=none; b=NzruEZTppCf0QqSzNqwJcl0YcRsS++aXvPh/m33DzspuyHdZMMV/cq3EH3X5OvOu5IcvSE6QTYILgfRPXw8N9STz8xzct+sCG++w4SV6j2RgynjEMVCO6o15mTQfSzabgq3Xt/GMVHkoBGElVOeJXZEwsUGhD39T2+XYFMUHbSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709248924; c=relaxed/simple;
	bh=Mkj5Sc6cI4FvOEnnNIhxUf9Wgrz2zaaYXGZLiY7koMk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oa9vCX6i2L/QPZ+yfZAROcFb+Zt1p2cREDY50ONWGDwwfr/aftHvswiZHnAV+Ao18kDtPBiUC4uFys17jO8dLmC5x5uFYvnv5BsRCezgmbIR+sDB7I1JI3oQ3CxBwUzWljh3o4LmRnCRZTEHP0AT/ipUqX1MzT6AaUph30olnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=RU9riOF2; arc=none smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="RU9riOF2"
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41TM5L9h013226
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 23:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=Z7PFKkTG0k1P08xGFl9pbKUOigPEDQm3V+RDcDyj/28=;
 b=RU9riOF2jpQ5F1qwDNukng1HlSV3bQT0AEMy1lh5ExS4uhyFMAvBjOaIdoW3q2ZNg0eQ
 z97GKUAfDUScvgqCyVJ0E4emlWSSb07DiKHY1zBxoYuTpp5L+togEt4RuXMhdVfo1xX0
 E/xckzic+nYaC2fU2/kHo88iHUYO9dIdCv4Znf9z1lRX2qusppX0CbJSQp0LFFVJDuks
 Ewdi8gQPvORzINCkc5JhJRq1oZ7YAjR3bMR/IGxs4Dizll50t7X7xSEiyyLM2WxldF87
 HeY+SITM1jsRFZPGusHKADtZD1cKZtagk4uJvJ16CUrJdMpx3Q/r285AQlHA5PQkNLl1 XQ== 
Received: from p1lg14878.it.hpe.com ([16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3wjxm0ubqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 23:22:01 +0000
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 3D140137A6
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 23:22:01 +0000 (UTC)
Received: from dog.eag.rdlabs.hpecorp.net (unknown [16.231.227.36])
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTP id D3892800EFE;
	Thu, 29 Feb 2024 23:22:00 +0000 (UTC)
Received: by dog.eag.rdlabs.hpecorp.net (Postfix, from userid 605001)
	id 854D630000AFB; Thu, 29 Feb 2024 17:12:31 -0600 (CST)
From: Justin Ernst <justin.ernst@hpe.com>
To: nvdimm@lists.linux.dev
Cc: Justin Ernst <justin.ernst@hpe.com>
Subject: [ndctl PATCH] util/json: Use json_object_get_uint64() with uint64 support
Date: Thu, 29 Feb 2024 17:11:51 -0600
Message-Id: <20240229231151.358694-1-justin.ernst@hpe.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 2njskqqXZjxUfkQAuSgGI_qvPy6Kv3QW
X-Proofpoint-ORIG-GUID: 2njskqqXZjxUfkQAuSgGI_qvPy6Kv3QW
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-29_06,2024-02-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=798 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402290183

If HAVE_JSON_U64=1, utils/json.c:display_hex() can call json_object_get_int64()
on a struct json_object created with json_object_new_uint64(). In the context of
'ndctl list --regions --human', this results in a static value of 0x7fffffffffffffff
being displayed for iset_id, as seen in #217.

Correct hex values are observed with the use of json_object_get_uint64(). To support
builds against older json-c, use a new static inline function util_json_get_u64() to
fallback to json_object_get_int64() if HAVE_JSON_U64=0.

Link: #217
Fixes: 691cd249 ("json: Add support for json_object_new_uint64()")
Signed-off-by: Justin Ernst <justin.ernst@hpe.com>
---
 util/json.c | 2 +-
 util/json.h | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/util/json.c b/util/json.c
index 1d5c6bc..ba9daa3 100644
--- a/util/json.c
+++ b/util/json.c
@@ -75,7 +75,7 @@ static int display_size(struct json_object *jobj, struct printbuf *pbuf,
 static int display_hex(struct json_object *jobj, struct printbuf *pbuf,
 		int level, int flags)
 {
-	unsigned long long val = json_object_get_int64(jobj);
+	unsigned long long val = util_json_get_u64(jobj);
 	static char buf[32];
 
 	snprintf(buf, sizeof(buf), "\"%#llx\"", val);
diff --git a/util/json.h b/util/json.h
index ea370df..a8d0283 100644
--- a/util/json.h
+++ b/util/json.h
@@ -34,10 +34,18 @@ static inline struct json_object *util_json_new_u64(unsigned long long val)
 {
 	return json_object_new_uint64(val);
 }
+static inline unsigned long long util_json_get_u64(struct json_object *jobj)
+{
+	return json_object_get_uint64(jobj);
+}
 #else /* fallback to signed */
 static inline struct json_object *util_json_new_u64(unsigned long long val)
 {
 	return json_object_new_int64(val);
 }
+static inline unsigned long long util_json_get_u64(struct json_object *jobj)
+{
+	return json_object_get_int64(jobj);
+}
 #endif /* HAVE_JSON_U64 */
 #endif /* __UTIL_JSON_H__ */
-- 
2.26.2

