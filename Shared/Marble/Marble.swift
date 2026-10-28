//
//  Marble.swift
//  Loom
//
//  Created by PEXAVC on 8/12/23.
//

import Foundation

struct MarbleOptions {
    static var enableFX: Bool = false
    static var fx: MarbleWebGLCatalog.FX = .granite
}

extension MarbleWebGLCatalog.FX {
    var speed: Double {
        switch self {
        case .bankai:
            return 0.025
        case .godrays:
            return 0.5
        case .waves:
            return 0.4
        default:
            return 1.0
        }
    }
}

//MARK: Local stand-in for MarbleKit
/*
 MarbleKit (github.com/pexavc/MarbleKit) is no longer reachable, so the
 subset Loom relies on lives here: the FX catalog and the glslCanvas
 fragment shaders used behind the custom YouTube player
 (see Write.Generate.shader). Shaders are embedded inside an HTML
 attribute, so they must not contain `"`, `&` or `<`.
 */
final class MarbleWebGLCatalog {
    static let shared: MarbleWebGLCatalog = .init()

    enum FX: String, CaseIterable, Identifiable, Codable, Hashable {
        case granite
        case bankai
        case godrays
        case waves

        var id: String { rawValue }

        //Persisted configs may hold FX that MarbleKit had and this catalog does not
        init(from decoder: Decoder) throws {
            let rawValue = try decoder.singleValueContainer().decode(String.self)
            self = FX(rawValue: rawValue) ?? .granite
        }
    }

    func load(_ fx: FX, speed: Double = 1.0) -> String? {
        let body: String
        switch fx {
        case .granite:
            body = Self.granite
        case .bankai:
            body = Self.bankai
        case .godrays:
            body = Self.godrays
        case .waves:
            body = Self.waves
        }

        return Self.header + "#define TIME (u_time * \(String(format: "%.4f", speed)))\n" + Self.noise + body
    }
}

extension MarbleWebGLCatalog {
    static let header: String = """
    #ifdef GL_ES
    precision mediump float;
    #endif
    uniform vec2 u_resolution;
    uniform float u_time;

    """

    static let noise: String = """
    float hash(vec2 p) {
        return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
    }
    float noise(vec2 p) {
        vec2 i = floor(p);
        vec2 f = fract(p);
        vec2 u = f * f * (3.0 - 2.0 * f);
        return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
                   mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
    }
    float fbm(vec2 p) {
        float v = 0.5 * noise(p);
        p *= 2.02;
        v += 0.25 * noise(p);
        p *= 2.03;
        v += 0.125 * noise(p);
        p *= 2.01;
        v += 0.0625 * noise(p);
        return v;
    }

    """

    static let granite: String = """
    void main() {
        vec2 uv = gl_FragCoord.xy / u_resolution.xy;
        vec2 p = uv * 6.0 + vec2(TIME * 0.05, TIME * 0.03);
        float veins = fbm(p + fbm(p + TIME * 0.02));
        float grain = hash(floor(uv * u_resolution.xy * 0.5));
        vec3 base = vec3(0.631, 0.604, 0.557);
        vec3 light = vec3(0.812, 0.792, 0.757);
        vec3 col = mix(base, light, smoothstep(0.3, 0.7, veins));
        col *= 0.92 + 0.08 * grain;
        gl_FragColor = vec4(col, 1.0);
    }
    """

    static let bankai: String = """
    void main() {
        vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        float r = length(uv);
        float a = atan(uv.y, uv.x);
        float swirl = fbm(vec2(a * 2.0 + TIME * 4.0, r * 4.0 - TIME * 6.0));
        float glow = smoothstep(0.9, 0.0, r) * swirl;
        vec3 col = vec3(0.9, 0.08, 0.1) * glow * 1.6;
        col += vec3(0.05) * fbm(uv * 10.0 + TIME);
        gl_FragColor = vec4(col, 1.0);
    }
    """

    static let godrays: String = """
    void main() {
        vec2 uv = gl_FragCoord.xy / u_resolution.xy;
        vec2 origin = vec2(0.5, 1.15);
        vec2 d = uv - origin;
        float a = atan(d.x, -d.y);
        float rays = fbm(vec2(a * 8.0, TIME * 0.4));
        rays = pow(rays, 2.0) * smoothstep(1.6, 0.2, length(d));
        vec3 col = mix(vec3(0.03, 0.04, 0.08), vec3(1.0, 0.92, 0.75), rays * 1.4);
        gl_FragColor = vec4(col, 1.0);
    }
    """

    static let waves: String = """
    void main() {
        vec2 uv = gl_FragCoord.xy / u_resolution.xy;
        float w = 0.0;
        w += sin(uv.x * 10.0 + TIME * 2.0) * 0.05;
        w += sin(uv.x * 23.0 - TIME * 3.0) * 0.02;
        w += (fbm(uv * 3.0 + TIME * 0.3) - 0.5) * 0.08;
        float band = fract((uv.y + w) * 8.0);
        float line = smoothstep(0.0, 0.08, band) * smoothstep(1.0, 0.6, band);
        vec3 deep = vec3(0.02, 0.10, 0.22);
        vec3 crest = vec3(0.35, 0.75, 0.95);
        gl_FragColor = vec4(mix(deep, crest, line * uv.y + 0.15), 1.0);
    }
    """
}
