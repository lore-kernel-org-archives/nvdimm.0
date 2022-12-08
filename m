Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEA4A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534938; x=1702070938;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b5zCfVzP38kgV3vnEfsEYSIHMCATSezT0YD9e5AI4I0=;
  b=SlpY7/GVIjIAnskb1LFuaJLBBAxWIZPlB4prTAe8qqvrAQIFvDlqc3A3
   HK0hsGgk5UlQLuVKpVvTjiiIDSxQW+9f4PaYU8b5b5wH2UM1mPhxccmTl
   RsOrkt8+q6mlpejZL2NfxKYEnsImbQBDXJ4xu84qjzPw/6nE8trcsmu7V
   IE3pHM28Gt7Z+fKu0UuUHEiTT/g+C1Zb/3BS76FElyRbkqu1keLWCwTXl
   nXOQvtAcP/Qo+H0CdNLX4ZrdYGF+zBimp8mHUj6HzsnuNGsRGbFrIL5JU
   ybQIRyiN1Xp68HlXXt1ZeuPT3/4vRD7V+DtZ57EE65eqeUjwkmyMHnX8P
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319170391"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="319170391"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753756193"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="753756193"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:57 -0800
Subject: [ndctl PATCH v2 10/18] cxl/list: Record cxl objects in json objects
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:57 -0800
Message-ID: <167053493696.582963.9963151335296712050.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for reusing 'cxl list' object selection in other utilities,
like 'cxl create-region', record the associated cxl object in the json
object. For example, enable 'cxl create-region -d decoderX.Y' to lookup the
memdevs that result from 'cxl list -M -d decoderX.Y'.

This sets up future design decisions for code that wants to walk the
topology. It can either open-code its own object walk, or get the json-c
representation of a query and use that. Unless the use case knows exactly
the object it wants it is likely more powerful to specify a
cxl_filter_walk() query and then walk the topology result.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/json.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 292e8428ccee..844bc089a4b7 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -365,6 +365,8 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		if (jobj)
 			json_object_object_add(jdev, "partition_info", jobj);
 	}
+
+	json_object_set_userdata(jdev, memdev, NULL);
 	return jdev;
 }
 
@@ -423,6 +425,7 @@ void util_cxl_dports_append_json(struct json_object *jport,
 			json_object_object_add(jdport, "id", jobj);
 
 		json_object_array_add(jdports, jdport);
+		json_object_set_userdata(jdport, dport, NULL);
 	}
 
 	json_object_object_add(jport, "dports", jdports);
@@ -446,6 +449,7 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 	if (jobj)
 		json_object_object_add(jbus, "provider", jobj);
 
+	json_object_set_userdata(jbus, bus, NULL);
 	return jbus;
 }
 
@@ -570,6 +574,7 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					       jobj);
 	}
 
+	json_object_set_userdata(jdecoder, decoder, NULL);
 	return jdecoder;
 }
 
@@ -628,6 +633,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 			json_object_object_add(jmapping, "decoder", jobj);
 
 		json_object_array_add(jmappings, jmapping);
+		json_object_set_userdata(jmapping, mapping, NULL);
 	}
 
 	json_object_object_add(jregion, "mappings", jmappings);
@@ -693,6 +699,7 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 
 	util_cxl_mappings_append_json(jregion, region, flags);
 
+	json_object_set_userdata(jregion, region, NULL);
 	return jregion;
 }
 
@@ -765,6 +772,7 @@ void util_cxl_targets_append_json(struct json_object *jdecoder,
 			json_object_object_add(jtarget, "id", jobj);
 
 		json_object_array_add(jtargets, jtarget);
+		json_object_set_userdata(jtarget, target, NULL);
 	}
 
 	json_object_object_add(jdecoder, "targets", jtargets);
@@ -807,6 +815,7 @@ static struct json_object *__util_cxl_port_to_json(struct cxl_port *port,
 			json_object_object_add(jport, "state", jobj);
 	}
 
+	json_object_set_userdata(jport, port, NULL);
 	return jport;
 }
 

