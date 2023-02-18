Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F3237B
	for <nvdimm@lists.linux.dev>; Sat, 18 Feb 2023 00:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676680835; x=1708216835;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=LT0dFcEhdmV5La+BwNbufwp+Qmm3U4wmcz4EnEgESaI=;
  b=oJIaBvkMIZSDQOJwLNrDPZ+J/1vWQhyowlVwm4fiuavEr5ktEgd9ZF0/
   KT9tS14GY2sBXD16T/rcofe25hQjciIbjaxJUjTS+304jJHCXxFKZ00iI
   AZiVTCoJSoDJKG1ZSwapO3xfTS7HAzpWw09Ix0Ms9yOjW0cdestoVZwqc
   J1WZJbkpAvfmQkL4rKMIsuG4Zv13frUyysR0ax5gJ3DhcdDa/cpTFDtGO
   7AH7a5kbagE5/Yv8R8eweJIyG3yBALIPawq/mRWKRHLTEB67zC05/ojwf
   8MEvT/XD2qbEPfJazrjdRykJxBTrLEuuv75efwUnZXeVw3q0ZJit6dCcM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="311754223"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="311754223"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 16:40:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="844749002"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="844749002"
Received: from basavana-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.2.127])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 16:40:32 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 17 Feb 2023 17:40:22 -0700
Subject: [PATCH ndctl 1/3] cxl/event_trace: fix a resource leak in
 cxl_event_to_json()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230217-coverity-fixes-v1-1-043fac896a40@intel.com>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
In-Reply-To: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=1014;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=LT0dFcEhdmV5La+BwNbufwp+Qmm3U4wmcz4EnEgESaI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMkf5OrtNqj9Oi8mONXFNjPnluU+xthEnnbvvT4pa5S41
 VhivrF0lLIwiHExyIopsvzd85HxmNz2fJ7ABEeYOaxMIEMYuDgFYCJf1BgZZtjvadkRZnKEMTJE
 hmO//yqT9osredXf/9rXO/fAcs6Zuxj++2YXJq2W6C733H7721n2dT7yupN+dy26Hfzx9Kdat5/
 veAE=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Static analysis reports that a 'return -ENOMEM' in the above function
bypasses the error unwinding and leaks 'jevent'.

Fix the error handling to use the right goto sequence before returning.

Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/event_trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index a973a1f..76dd4e7 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -142,7 +142,8 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
 				jobj = num_to_json(data, f->elementsize, f->flags);
 				if (!jobj) {
 					json_object_put(jarray);
-					return -ENOMEM;
+					rc = -ENOMEM;
+					goto err_jevent;
 				}
 				json_object_array_add(jarray, jobj);
 				data += f->elementsize;

-- 
2.39.1

