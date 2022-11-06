Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9C1D500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778452; x=1699314452;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=50C5Ti/DQPn7bUI/tAY6ANpsUzgERwK8XGH+P1LDbkU=;
  b=kIbOqnglYTEaNiiWdtMI9fS0hYRYKZhvamEsc26GxyW0BaOvWSDYbWME
   kxvoY9qc7Xyt6SW0BjJ+0opwGjBGeHHoxx5OWJcxPx8Y1isMfwjQsJPF7
   4Iq6xETFzbxgVDGgf+XTF+iybdM76UVbp9bHiqIwvBN2IksRfYNBjaBxw
   57UoiFq5LZZQlH24UTpLuKjTyQrX3jPtUNpXuZ/e0uTcb2wUyjNKjh82y
   ZZDUK4QLan104APvSm7UxhPMyVmmTDDbPlkpduaCMP54B+NL3mv0cWHeJ
   8BD+WiWG5t432cMD2tox3CQdzgG3zMu4YsuYf2QbtA2H1rtz8iX+Ps9VR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="312052601"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="312052601"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704674732"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704674732"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:32 -0800
Subject: [ndctl PATCH 08/15] cxl/list: Record cxl objects in json objects
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:47:31 -0800
Message-ID: <166777845158.1238089.3583136384580175866.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
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
index 1b1669ab021d..9264f5fcb21e 100644
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
 
@@ -416,6 +418,7 @@ void util_cxl_dports_append_json(struct json_object *jport,
 			json_object_object_add(jdport, "id", jobj);
 
 		json_object_array_add(jdports, jdport);
+		json_object_set_userdata(jdport, dport, NULL);
 	}
 
 	json_object_object_add(jport, "dports", jdports);
@@ -439,6 +442,7 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 	if (jobj)
 		json_object_object_add(jbus, "provider", jobj);
 
+	json_object_set_userdata(jbus, bus, NULL);
 	return jbus;
 }
 
@@ -563,6 +567,7 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					       jobj);
 	}
 
+	json_object_set_userdata(jdecoder, decoder, NULL);
 	return jdecoder;
 }
 
@@ -621,6 +626,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 			json_object_object_add(jmapping, "decoder", jobj);
 
 		json_object_array_add(jmappings, jmapping);
+		json_object_set_userdata(jmapping, mapping, NULL);
 	}
 
 	json_object_object_add(jregion, "mappings", jmappings);
@@ -686,6 +692,7 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 
 	util_cxl_mappings_append_json(jregion, region, flags);
 
+	json_object_set_userdata(jregion, region, NULL);
 	return jregion;
 }
 
@@ -751,6 +758,7 @@ void util_cxl_targets_append_json(struct json_object *jdecoder,
 			json_object_object_add(jtarget, "id", jobj);
 
 		json_object_array_add(jtargets, jtarget);
+		json_object_set_userdata(jtarget, target, NULL);
 	}
 
 	json_object_object_add(jdecoder, "targets", jtargets);
@@ -785,6 +793,7 @@ static struct json_object *__util_cxl_port_to_json(struct cxl_port *port,
 			json_object_object_add(jport, "state", jobj);
 	}
 
+	json_object_set_userdata(jport, port, NULL);
 	return jport;
 }
 

